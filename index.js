
let express = require("express");
let app = express();
const bodyParser = require("body-parser");
let methodOverride = require("method-override");
let path = require("path");

let flash = require("connect-flash");
const { triggerAsyncId } = require("async_hooks");

const bcrypt = require("bcrypt");
let session = require("express-session");
const pgSession = require("connect-pg-simple")(session);
const sessionPool = require("pg").Pool;

const { Pool } = require("pg");

const connectionString ="postgresql://postgres:root@localhost:5432/BookShop";
// const connectionString ="postgres://vasceujh:kgoMtpiQKZ2gDHqwGsSuaFTWFc85ilak@hansken.db.elephantsql.com/vasceujh";
const pool = new Pool({ connectionString });
const sessionDBaccess = new sessionPool({ connectionString });

let DB = require("./router/queries");
const e = require("connect-flash");

//---------------------Sql injection---------------
app.use(flash());
app.use(
  session({
    store: new pgSession({
      pool: sessionDBaccess,
      tableName: "",
    }),
    name: "_uuid",
    secret: "opsecert",
    resave: false,
    saveUninitialized: false,
  })
);

app.set("views", path.join(__dirname, "/views"));
app.set("view engine", "ejs");
app.use(methodOverride("_method"));
app.use(express.static(path.join(__dirname, "public")));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());
app.use((req, res, next) => {
  let body = JSON.stringify(req.body).replace(/'|--|;/g, " ");
  let query = JSON.stringify(req.query).replace(/'|--|;/g, " ");
  let parms = JSON.stringify(req.params).replace(/'|--|;/g, " ");
  req.body = JSON.parse(body);
  req.params = JSON.parse(parms);
  req.query = JSON.parse(query);
  next();
});

// setting date function to display it in the request format
function setdate(d) {
  let x = new Date(d);
  return `${x.getDate() + 1 < 10 ? "0" + x.getDate() : x.getDate()}-${
    x.getMonth() + 1 < 10 ? "0" + (x.getMonth() + 1) : x.getMonth() + 1
  }-${x.getFullYear()}`;
}
function setdateEv(d) {
  let x = new Date(d);
  return `${x.toLocaleString("en-US", {
    month: "short",
  })} ${x.getDate()}, ${x.getFullYear()}`;
}
function setdateBOOK(d) {
  let x = new Date(d);
  return `${x.getDate()} ${x.toLocaleString("en-US", {
    month: "short",
  })} ,${x.getFullYear()}`;
}
function setdatetotal(d) {
  let x = new Date(d);
  return `${x.getDate()} ${x.toLocaleString("en-US", { month: "short" })} `;
}

//userIn middleware
app.use(async (req, res, next) => {
  if (typeof req.session.user_In === "undefined") req.session.user_In = null;
  next();
});
// our password hash function
let HashPass = async (password) => {
  let salt = await bcrypt.genSalt(12);
  let hash = await bcrypt.hash(password, salt);
  return hash;
};
//check password with hashed one
let login = async (pw, hashedpw) => {
  let result = await bcrypt.compare(pw, hashedpw);
  return result;
};
//to show akk books if no q
let showallBooks = (req, res, next) => {
  if (!req.query.q) req.query.q = "All Genre";
  if (!req.query.active) req.query.active = "All Genre";
  next();
};
//-------------------------------------- Home  -----------------------------------------------------------------------

// the main page route
app.get("/", async (req, res,next) => {
  try {
    let re = await DB.homeMostRatedBooks();
    let homeGetlateest = await DB.homeGetLatestArivals();
    books = await DB.homeMostPopularBooks();
    let featured = await DB.homeFeaturedBooks();
    tags = await DB.Alltags();
    events = await DB.homeLatestEvents();
    featured.forEach((e) => {
      e.date_published = setdate(e.date_published);
    });
    books.forEach((e) => {
      e.date_published = setdate(e.date_published);
    });
    homeGetlateest.forEach((e) => {
      e.date_published = setdate(e.date_published);
    });
    events.forEach((e) => {
      e.due_to = setdateEv(e.due_to);
    });
    res.render("index", {
      MostRated: re,
      latest: homeGetlateest,
      featured,
      books,
      tags,
      events,
      userIn: req.session.user_In,
    });
  } catch (e) {
    res.redirect("/404page");
  }
});

//-------------------------------------- Search -----------------------------------------------------------------------

// the get route for  the search request that handle showing all books and normal search
app.get("/search", showallBooks, async (req, res) => {
  try {
    let result = null;
    const { q } = req.query;
    if (q == "All Genre") {
      result = await DB.AllBooks();
    } else {
      result = await DB.SearchBookByQ(q.trim());
    }
    let cart =
      req.session.user_In == null
        ? []
        : await DB.getCart(req.session.user_In.user_id);
    let t = await DB.Alltags();
    res.render("search", {
      q,
      result,
      cart,
      tags: t,
      active: "All Genre",
      userIn: req.session.user_In,
    });
  } catch (error) {
    res.redirect("/page404");
  }
});
//search by tag route
app.get(
  "/searchtag",
  async (req, res) => {
    // try{
    let { tag } = req.query;
    let result = await DB.SearchBookByTag(tag);
    if (tag == "All Genre") {
      result = await DB.AllBooks();
    }
    let cart =
      req.session.user_In == null
        ? []
        : await DB.getCart(req.session.user_In.user_id);
    let t = await DB.Alltags();
    res.render("search", {
      q: "",
      result,
      cart,
      tags: t,
      active: tag,
      userIn: req.session.user_In,
    });
  }
  // catch(e){
  //   res.redirect('/');
  // }
);
//change the tag in the page
app.post("/searchtag", async (req, res) => {
  try {
    let { tag } = req.body;
    let result = await DB.SearchBookByTag(tag);
    if (tag == "All Genre") {
      result = await DB.AllBooks();
    }
    let cart =
      req.session.user_In == null
        ? []
        : await DB.getCart(req.session.user_In.user_id);
    let t = await DB.Alltags();
    res.render("search", {
      q: "",
      result,
      cart,
      tags: t,
      active: tag,
      userIn: req.session.user_In,
    });
  } catch (e) {
    res.redirect("/searchtag");
  }
});

//-------------------------------------- Book page -----------------------------------------------------------------------

//the get route for books to show books details by id
app.get("/book/:id", async (req, res, next) => {
  try {
    let { id } = req.params;
    if (id.length > 32) {
      let a = await DB.getBook(id);
      let t = await DB.getBooktags(id);
      let b3 = await DB.getBookRev(id);
      let book = a[0];
      book.date_published = setdateEv(book.date_published);
      book.tags = t;
      book.reviews = b3;
      book.reviews.forEach((r) => {
        r.review_date = setdateEv(r.review_date);
      });
      book.reviewsCnt = b3.length;
      let matched = await DB.getSameTags(id, 6);
      matched = matched.filter((e) => e.book_id != id);

      cart =
        req.session.user_In == null
          ? []
          : await DB.getCart(req.session.user_In.user_id);
      res.render("book_page", {
        book,
        cart,
        matched,
        userIn: req.session.user_In,
      });
    } else res.redirect("back");
  } catch (e) {
    res.redirect("/signin");
  }
});
app.post("/addcomment", async (req, res) => {
  try {
    if (req.session.user_In) {
      await DB.addRatingWithReview(
        req.body.id,
        req.session.user_In.user_id,
        parseInt(req.body.rate),
        req.body.description
      );
    }
    res.redirect(`/book/${req.body.id}`);
  } catch (e) {
    res.redirect(`/book/${req.body.id}`);
  }
});

//-------------------------------------- Events -----------------------------------------------------------------------

// the get route for events page to show all avl events
app.get("/events", async (req, res) => {
  try {
    let cart =
      req.session.user_In == null
        ? []
        : await DB.getCart(req.session.user_In.user_id); // check if user login get his cart from the DB else return empty array
    let event = await DB.AllEvents(); // get all events to show in the page
    let echeck =
      req.session.user_In == null
        ? []
        : await DB.checkEvents(req.session.user_In.user_id); // to check if the current user booked a ticket for the event or not
    let check = echeck.map((object) => object.event_id); // to get map the returned obj from DB to array
    res.render("events", {
      events: event,
      cart,
      userIn: req.session.user_In,
      check,
      messages: req.flash("Accept"),
    });
  } catch (e) {
    res.redirect("/signin");
  }
});

//book a ticket Event with event Id
app.post("/bookticket", async (req, res) => {
  try {
    let test = await DB.bookTicket(
      req.body.event_id,
      req.session.user_In.user_id
    );
    if (test == 1) {
      req.flash("Accept", `You Have successfully book a ticket `);
    } else {
      req.flash("Accept", `oops somthing happend ,try again later`);
    }
    res.redirect("/events");
  } catch (e) {
    res.redirect("/signin");
  }
});

//-------------------------------------- Blogs -----------------------------------------------------------------------

// the get route for blogs page
app.get("/blogs", async (req, res) => {
  try {
    blgs = await DB.AllBlogs(); // get all blogs from DB
    blgs.forEach((e) => {
      e.date_posted = setdate(e.date_posted);
    }); //set the date with format
    books = await DB.getAllBooks(); //get all Books names from DB to show in the drop box in adding a new blog
    let cart =
      req.session.user_In == null
        ? []
        : await DB.getCart(req.session.user_In.user_id); // check cart
    res.render("Blogs", { blgs, cart, books, userIn: req.session.user_In });
  } catch (e) {
    res.redirect("/page404");
  }
});
//add new blog
app.post("/blogs", async (req, res) => {
  try {
    let newblog = req.body;
    if (req.session.user_In) {
      let re = await DB.addNewBlog(
        req.session.user_In.user_id,
        newblog.title.replace(/'/g, " "),
        newblog.description.replace(/'/g, " "),
        newblog.blog_title
      );
    }
    res.redirect("/blogs");
  } catch (e) {
    res.redirect("/signin");
  }
});
//delete blog with id
app.delete("/deleteBlog", async (req, res, next) => {
  try {
    const { id } = req.body;
    let x = await DB.deleteBlog(id);
    res.redirect("/blogs");
  } catch (e) {
    res.redirect("/blogs");
  }
});
////edit data blog with  blog_id
app.post("/editblog", async (req, res) => {
  try {
    let { id, name, title, description } = req.body;
    await DB.UpdateBlog(
      id,
      title.replace(/'/g, " "),
      name,
      description.replace(/'/g, " ")
    );
    res.redirect(`/blogs#${id}2`);
  } catch {
    res.redirect(`/blogs`);
  }
});

//-------------------------------------- SignIn / login /log out -----------------------------------------------------------------------
//the get route for SignIn page
app.get("/signin", async (req, res) => {
  let cart = []; //for the nav bar cart to show [] as no items for new users
  if (req.session.user_In == null)
    // if new user sign in else hide the page
    res.render("signin", {
      cart,
      userIn: req.session.user_In,
      messages: req.flash("error"),
    });
  else res.redirect("/page404");
});

//login
app.post("/", async (req, res) => {
  try {
    let { username, pass, userType } = req.body; // get user input information from login form
    let signeduser = await DB.login(username); //check if the username in the DB or not
    if (signeduser) {
      if (await login(pass, signeduser[0].pass)) {
        //check the input password with the Saved password
        if (signeduser[0].user_type == userType ||signeduser[0].user_type == "Admin") {
          //Check user type or if admin neglect it
          req.session.user_In = signeduser[0]; // save the user information in his browser to keep login
          res.redirect("/");
        } else {
          req.flash("error", "Error: Wrong UserType"); //pop error to inform user with his mistake
          res.redirect("/signin");
        }
      } else {
        req.flash("error", "Error: Wrong name or password");
        res.redirect("/signin");
      }
    } else {
      req.flash("error", "Error: Wrong name or password");
      res.redirect("/signin");
    }
  } catch (error) {
    res.redirect("/page404");
  }
});

// first page date saved in user browser
app.post("/signup", async (req, res) => {
  req.session.userdata = req.body;
  let checkUser = await DB.checkUsername(req.session.userdata.username);
  if (checkUser == 0) res.redirect("/tags");
  else res.redirect("back");
});

// sign up 2nd page to continue the missing information from user
app.get("/tags", async (req, res) => {
  try {
    let cart = [];
    let tags = await DB.Alltags();
    res.render("tags", { cart, tags, userIn: req.session.user_In });
  } catch (e) {
    res.redirect("/signin");
  }
});
//successfully insert the new user information in the DB
app.post("/newUser", async (req, res) => {
  try {
    req.session.userdata = Object.assign(req.body, req.session.userdata);
    let user = req.session.userdata; //var with all newUser information
    user.pass = await HashPass(user.pass);
    let Login = await DB.signIn(
      user.username,
      user.pass,
      user.FirstName,
      user.LastName,
      user.userType,
      user.Gender,
      parseInt(user.balance),
      user.yyyy + "-" + user.mm + "-" + user.dd,
      user.City,
      (user.photo =
        user.photo ||
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png"),
      user.tags
    );
    //login the new user after sign up
    req.session.user_In = await Login;

    res.redirect("/");
  } catch (e) {
    res.redirect("/page404");
  }
});
// simply remove the user saved data
app.post("/loggout", async (req, res) => {
  try {
    req.session.user_In = null;
    req.session.destroy();
    res.redirect("/");
  } catch (e) {
    res.redirect("/signin");
  }
});

//-------------------------------------- users Profiles-----------------------------------------------------------------------

app.get("/profile/:username", async (req, res) => {
  try {
    //initialize profile data from DB with the username
    let { username } = req.params;
    let books = [];
    let bestBooks = [];
    let tag = [];
    let recentBooks = [];
    let Revcount = 0;
    let BlogCount = 0;
    let profileuser = await DB.getuser(username);
    let user_type = profileuser.user_type;
    let blog = await DB.userBlogs(username);
    let tags = await DB.Alltags();

    // check if the profile is for admin or reader to show last  bought books with different  categories
    if (user_type == "Reader" || user_type == "Admin") {
      bestBooks = await DB.readerBestBooks(username);
      books = await DB.readerAllBooks(username);
      recentBooks = await DB.readerRecentBooks(username);
      tag = await DB.userTags(username);
    }
    // show the author books
    else {
      bestBooks = await DB.bestBooksAuthor(username);
      books = await DB.AuthorBooks(username);
      recentBooks = await DB.AuthorBooks(username);
      tag = await DB.userTags(username);
    }
    // get the different counts for the profile
    let profileCounts = await DB.profileCounts(username);
    Revcount = profileCounts[0].review_count;
    BlogCount = profileCounts[0].blog_count;
    blog.forEach((e) => {
      e.date_posted = setdate(e.date_posted);
    });
    res.render("profile", {
      userIn: req.session.user_In,
      books,
      bestBooks,
      recentBooks,
      Revcount,
      blog,
      BlogCount,
      tag,
      tags,
      profileuser,
    });
  } catch (e) {
    res.redirect("/signin");
  }
});
// edit the user profile with new data
app.post("/editprofile", async (req, res) => {
  try {
    await DB.editProfile(
      req.session.user_In.username,
      req.body.photo,
      req.body.cover,
      req.body.username
    );
    req.session.user_In.profile_pic = req.body.photo;
    req.session.user_In.cover = req.body.cover;
    req.session.user_In.username = req.body.username;
    res.redirect(`profile/${req.body.username}`);
  } catch (e) {
    res.redirect("/signin");
  }
});

//-------------------------------------- Nav bar -----------------------------------------------------------------------

// for the changing password a simple request to test if the user password is correct or not and return the ans
app.post("/checkpassword", async (req, res) => {
  try {
    let { oldpass } = req.body;
    let signeduser = await DB.login(req.session.user_In.username);
    let check = await login(oldpass, signeduser[0].pass);
    if (check) {
      res.json({ ans: 1 });
    } else {
      res.json({ ans: 0 });
    }
  } catch (e) {
    res.json({ ans: 0 });
  }
});

//change the user current password with the new password
app.post("/changepass", async (req, res) => {
  try {
    let { oldpass, newpass } = req.body;
    let signeduser = await DB.login(req.session.user_In.username);
    let x = await HashPass(newpass);
    await DB.ChangePassword(signeduser[0].user_id, x);
    res.redirect("back");
  } catch (e) {
    res.redirect("back");
  }
});
// add money to user balance
app.post("/addmoney", async (req, res, next) => {
  try {
    if (parseInt(req.body.money) > 1) {
      let newBalance =
        parseInt(req.body.money) + parseInt(req.session.user_In.balance);
      await DB.SetuserBalance(req.session.user_In.user_id, newBalance);
      req.session.user_In.balance = newBalance;
    }
    res.redirect("back");
  } catch (e) {
    res.redirect("back");
  }
});

//Add a newbook from the pop up in the navbar
app.post("/newbook", async (req, res) => {
  try {
    let book = req.body;
    book.author = req.session.user_In.name;
    book.date = `${book.yyyy}-${book.mm}-${book.dd}`;

    var others = book.Author.split(/,/);
    if (book.Author == "") others = [];

    let tags = Array.from(book.tags);
    let newbook = await DB.addBook(
      req.session.user_In.user_id,
      book.sequel,
      book.title,
      parseInt(book.price),
      book.photo,
      1,
      book.date,
      parseInt(book.Chapters),
      parseInt(book.age),
      book.description.replace(`'`, " "),
      others,
      tags
    );
    res.redirect("/");
  } catch (e) {
    res.redirect("back");
  }
});

//-------------------------------------- Cart -----------------------------------------------------------------------
//Display cart page
app.get("/cart", async (req, res) => {
  try {
    let x = await DB.getCart(req.session.user_In.user_id);
    res.render("cart", { cart: x, userIn: req.session.user_In });
  } catch (e) {
    res.redirect("/signin");
  }
});
//add book with given qty to the cart
app.post("/book/:id", async (req, res) => {
  try {
    if (req.session.user_In != null) {
      let { qty, id } = req.body;
      await DB.AddtoCart(req.session.user_In.user_id, id, qty);
    } else {
      res.redirect("/signin");
    }
  } catch (e) {
    res.redirect("/signin");
  }
});
//Delete oreder from cart
app.delete("/delete", async (req, res, next) => {
  try {
    let { id } = req.body;
    await DB.DeleteOrder(id);
    next();
  } catch (e) {
    res.redirect("/signin");
  }
});
//inc order counter
app.post("/putinc", async (req, res, next) => {
  try {
    let { id } = req.body;
    await DB.updateOrder(id, 1);
    next();
  } catch (e) {
    res.redirect("/signin");
  }
});
//dec order counter
app.post("/putdec", async (req, res, next) => {
  try {
    let { id } = req.body;
    await DB.updateOrder(id, -1);
    next();
  } catch (e) {
    res.redirect("/signin");
  }
});
//process chehckout
app.post("/checkOut", async (req, res, next) => {
  try {
    if (req.session.user_In.balance >= req.body.cost) {
      await DB.checkOut(
        req.body.id,
        req.session.user_In.balance - req.body.cost
      );
      req.session.user_In.balance = req.session.user_In.balance - req.body.cost;
    }
    next();
  } catch (e) {
    res.redirect("/signin");
  }
});

//-------------------------------------- Borrow Books -----------------------------------------------------------------------

//BorrowBooks get route page
app.get("/BorrowBooks", async (req, res, next) => {
  try {
    let NotReturned = await DB.borrowNotReturned(req.session.user_In.user_id);
    NotReturned.forEach((e) => (e.return_date = setdate(e.return_date)));
    let Returned = await DB.borrowReturned(req.session.user_In.user_id);
    Returned.forEach((e) => (e.return_date = setdate(e.return_date)));

    let cart =
      req.session.user_In == null
        ? []
        : await DB.getCart(req.session.user_In.user_id);
    res.render("Borrowed", {
      NotReturned,
      Returned,
      q: "",
      cart,
      userIn: req.session.user_In,
      messages: req.flash("Success"),
    });
  } catch (e) {
    res.redirect("signin");
  }
});

// return a borrowed book
app.post("/returnbook", async (req, res) => {
  try {
    let { id } = req.body;
    req.flash("Success", "Thanks for your discipline");
    await DB.returnBook(req.session.user_In.user_id, id);
    res.redirect("/BorrowBooks");
  } catch (e) {
    res.redirect("/BorrowBooks");
  }
});
// borrow a book from the book page with book_Id
app.post("/borrow", async (req, res) => {
  try {
    let { id } = req.body;
    let x = await DB.borrowBook(req.session.user_In.user_id, id);
    res.redirect("/BorrowBooks");
  } catch (e) {
    res.redirect("/BorrowBooks");
  }
});

//time track
app.post("/test", async (req, res) => {
  let { visits, timeOnPage } = req.body;
  let now = new Date();
  let date = `${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}`;
  let checkDate = await DB.StatGetDate(date);
  
  if (checkDate == 0) {
    await DB.addStat(date);
  } else {
    await DB.updateStat(date, timeOnPage, visits);
  }
});
app.post("/getstat", async (req, res) => {
  let x = await DB.Getstat();
  res.json(x);
});

//-------------------------------------- Admin pages -----------------------------------------------------------------------
//DashBored with validation
app.get("/admin", async (req, res) => {
  try {
    if (req.session.user_In.user_type == "Admin") {
      let BooksToApprove = await DB.BooksToApprove();
      BooksToApprove.forEach(
        (e) => (e.date_published = setdateBOOK(e.date_published))
      );
      let TotalIncome = await DB.TotalIncome();
      TotalIncome.cur_date = setdatetotal(TotalIncome.cur_date);
      TotalIncome.last_week_date = setdatetotal(TotalIncome.last_week_date);
      let TotalOrder = await DB.TotalOrder();
      TotalOrder.cur_date = setdatetotal(TotalOrder.cur_date);
      TotalOrder.last_week_date = setdatetotal(TotalOrder.last_week_date);
      if (TotalOrder.order == null) {
        TotalOrder.order = 0;
      }
      let TotalUsers = await DB.TotalUsers();
      TotalUsers.cur_date = setdatetotal(TotalUsers.cur_date);
      TotalUsers.last_week_date = setdatetotal(TotalUsers.last_week_date);

      let TotalBlogs = await DB.TotalBlogs();
      TotalBlogs.cur_date = setdatetotal(TotalBlogs.cur_date);
      TotalBlogs.last_week_date = setdatetotal(TotalBlogs.last_week_date);

      res.render("DashBoard", {
        BooksToApprove,
        TotalIncome,
        TotalOrder,
        TotalUsers,
        TotalBlogs,
        userIn: req.session.user_In,
      });
    } else res.redirect("/page404");
  } catch (e) {
    res.redirect("/page404");
  }
});
//accept new BOOK
app.post("/acceptBOOK", async (req, res) => {
  try {
    await DB.AcceptBook(req.body.id);
    res.redirect("/admin");
  } catch (e) {
    res.redirect("/admin");
  }
});
//Decline new BOOK
app.post("/declineBook", async (req, res) => {
  try {
    await DB.DeclineBook(req.body.id);
    res.redirect("/admin");
  } catch (e) {
    res.redirect("/admin");
  }
});

app.get("/admin/users", async (req, res) => {
  try {
    let users = await DB.allUsers();
    res.render("AdminUsers", { users, userIn: req.session.user_In });
  } catch (e) {
    res.redirect("/signin");
  }
});
app.delete("/deleteUser", async (req, res) => {
  try {
    await DB.DeleteUser(req.body.id);
    res.redirect("/admin/users");
  } catch (e) {
    res.redirect("/signin");
  }
});
app.post("/admin/setAdmin", async (req, res) => {
  try {
    await DB.SetAdmin(req.body.id);
    res.redirect("/admin/users");
  } catch (e) {
    res.render("/signin");
  }
});
app.post("/admin/getdata", async (req, res) => {
  let x = await DB.totalincomeinmonth();
  res.json(x);
});
app.get("/admin/event", async (req, res) => {
  res.render("AdminEvent", { userIn: req.session.user_In });
});

app.post("/admin/addevent", async (req, res) => {
  req.body.due_to = `${req.body.yyyy}-${req.body.mm}-${req.body.dd}`;

  await DB.AddEvent(
    req.body.Location,
    req.body.tickets,
    req.body.price,
    req.body.title.replace(/'/g, " "),
    req.body.due_to,
    req.body.description.replace(/'/g, " "),
    req.body.cover
  );
  res.redirect("/admin/event");
});

app.get("/myOrders", async (req, res, next) => {
  try {
    let orders = await DB.pastOrders(req.session.user_In.user_id);
    orders.forEach((e) => {
      e.date_published = setdate(e.assign_date);
    });
    res.render("myOrders", { orders, cart: [], userIn: req.session.user_In });
  } catch (e) {
    res.redirect("/signin");
  }
});
//-------------------------------------- Server -----------------------------------------------------------------------

app.listen(process.env.PORT || "8000", () => {
  console.log(`launched on port 8000`);
});
app.get("/page404", async (req, res) => {
  let cart =
    req.session.user_In == null
      ? []
      : await DB.getCart(req.session.user_In.user_id);
  res.render("page404", { cart, userIn: req.session.user_In });
});
app.use(async (req, res, next) => {
  let cart = []
  if(req.session.user_In)
  {
    cart = await DB.getCart(req.session.user_In.user_id);
    req.session.user_In.balance = await DB.getuserBalance(req.session.user_In.user_id)
  }
  res.render("page404", { cart, userIn: req.session.user_In });
  next();
});
