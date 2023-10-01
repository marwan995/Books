const { Pool, Client } = require('pg')
const connectionString ="postgresql://postgres:root@localhost:5432/BooksShop";


const pool = new Pool({
  connectionString,
})


module.exports.homeMostRatedBooks = async () => {                      //Used in the home page to get the most rated books

  let result = await pool.query('SELECT distinct * FROM book WHERE accepted = TRUE ORDER BY rating DESC LIMIT 4;');
  return result.rows;
}

module.exports.checkUsername = async (username) => {
  let res = await pool.query(`SELECT username FROM reader WHERE username = '${username}';`);
  return res.rowCount;
}


module.exports.homeGetLatestArivals = async () => {                  //Used in the home page to get the latest books

  let result = await pool.query('SELECT * FROM book AS b JOIN (SELECT max(author_id) AS author_id,book_id FROM writes GROUP BY book_id) AS w ON w.book_id = b.book_id JOIN reader AS r ON r.user_id = w.author_id WHERE b.accepted = TRUE ORDER BY b.date_published DESC LIMIT 5;');
  return result.rows;
}


module.exports.getCart = async (userID) => {         //to get incompleted order of a user
  let result = await pool.query(`SELECT o.*,b.* FROM my_order AS o JOIN reader AS r ON r.user_id = o.user_id JOIN book AS b ON b.book_id = o.book_id WHERE o.is_completed = FALSE AND r.user_id = '${userID}'`);
  return result.rows;
}

module.exports.AllBooks = async () => {         //to get allbooks

  let result = await pool.query(`select *, COALESCE(sub2.review_count,0) AS reviews from book AS b JOIN (SELECT b2.book_id, MAX(r.username) AS username FROM writes AS w JOIN reader AS r ON r.user_id = w.author_id JOIN book AS b2 ON b2.book_id = w.book_id GROUP BY b2.book_id ) AS sub ON b.book_id = sub.book_id left JOIN (SELECT b3.book_id,COUNT(*) AS review_count FROM review AS rev right JOIN book AS b3 ON b3.book_id = rev.book_id GROUP BY b3.book_id) AS sub2 ON sub2.book_id = sub.book_id where accepted=true;`);
  return result.rows;
}

module.exports.homeFeaturedBooks = async () => {              //to get featured books

  let result = await pool.query('SELECT b.*,r.* FROM book AS b JOIN (SELECT max(author_id) AS author_id,book_id FROM writes GROUP BY book_id) AS w ON w.book_id = b.book_id JOIN reader AS r ON r.user_id = w.author_id WHERE accepted = TRUE ORDER BY date_published DESC,rating DESC LIMIT 15;');
  return result.rows;
}
module.exports.Alltags = async () => {              //to get featured books


  let result = await pool.query('SELECT tag_name from tag ORDER BY tag_name ASC ;');
  return result.rows;
}


module.exports.homeLatestEvents = async () => {         //to get the latest 6 events

  let result = await pool.query('SELECT * FROM events ORDER BY due_to ASC LIMIT 6;');
  return result.rows;
}

module.exports.homeMostPopularBooks = async () => {         //to get the most popular books

  let result = await pool.query('SELECT b.*,r.*,c.book_count FROM book AS b JOIN (SELECT max(author_id)AS author_id, book_id FROM writes GROUP BY book_id ) as w on b.book_id = w.book_id JOIN reader AS r ON w.author_id = r.user_id JOIN ( SELECT o1.book_id AS book_id ,COUNT(o1.book_id) as book_count FROM book as b1 JOIN my_order as o1 ON b1.book_id = o1.book_id group by b1.book_id,o1.book_id) AS c ON b.book_id = c.book_id WHERE b.accepted = TRUE ORDER BY c.book_count DESC, b.rating DESC LIMIT 8;');
  return result.rows;
}


//blogs
module.exports.LatestBlogs = async (bookname) => {         //to get all books an author wrote


  let result = await pool.query(`SELECT * from blog where blog.book_id = (select book_id from book where title = '${bookname}') order by date_posted;
`);
  return result.rows;
}


module.exports.getAllBooks = async () => {         //to get all books

  let result = await pool.query(`select title from book where accepted = true;`);
  return result.rows
}

module.exports.AllBlogs = async () => {

  let result = await pool.query(`select bg.user_id, bg.blog_id, bg.blog_title, bg.date_posted, b.photo, b.title, b.rating ,bg.book_id, bg.description, r.username
from blog as bg, book as b, reader as r where bg.book_id = b.book_id and bg.user_id = r.user_id ORDER BY bg.date_posted DESC;`);

  return result.rows;
}

module.exports.deleteBlog = async (blogID) => {

  let result = await pool.query(`
DELETE from blog where blog_id ='${blogID}';
`);
  return result.rows;
}

module.exports.addNewBlog = async (userID, title, desc, blogTitle) => {
  let bookID = await pool.query(`SELECT book_id FROM book WHERE title = '${title}'`);
  const values = [`${bookID.rows[0].book_id}`, `${userID}`, `${blogTitle}`, `${desc}`]
  const text = 'INSERT INTO blog(book_id, user_id, blog_title, description) VALUES($1, $2, $3, $4) RETURNING *'
  let result = await pool.query(text, values);

  return result.rows;
}
module.exports.UpdateBlog = async (id, title, name, des) => {

  let result = await pool.query(`
  UPDATE blog set blog_title = '${title}', description = '${des}', book_id = (SELECT book_id from book where title = '${name}') where blog.blog_id = '${id}';`);
  return result.rows;
}
// BOOk
module.exports.getBook = async (bookId) => {
  let b1 = await pool.query(`SELECT b.*, r.username from book as b, reader as r, writes as w
  where b.accepted = true and w.author_id = r.user_id and w.book_id = b.book_id and b.book_id = '${bookId}';`)
  return b1.rows
}
module.exports.getBooktags = async (bookId) => {

  let b2 = await pool.query(`SELECT t.tag_name from book as b, tag as t, book_tag as bt
  where b.accepted = true and b.book_id = '${bookId}'
  and bt.book_id = b.book_id and bt.tag_id = t.tag_id;`)
  return b2.rows

}
module.exports.getBookRev = async (bookId) => {

  let b3 = await pool.query(`SELECT  r.*, rd.profile_pic, rd.username, rd.user_id from review as r, book as b, reader as rd
  where r.book_id = '${bookId}' and b.book_id = r.book_id
  and r.user_id = rd.user_id;
  `)

  return b3.rows;
}
module.exports.getBookSequel = async (sequel) => {

  let res = await pool.query(`SELECT b2.* FROM book AS b2 WHERE title = '${sequel}'`)

  return res.rows;
}
module.exports.getSameTags = async (bookId, l) => {

  let res = await pool.query(`select * from
  (SELECT  b1.*,r.*,ROW_NUMBER() OVER(PARTITION BY b1.book_id ORDER BY r.username) AS my_row
   FROM book AS b1 JOIN book_tag AS bt1 ON bt1.book_id = b1.book_id JOIN writes AS w ON b1.book_id = w.book_id JOIN reader AS r ON r.user_id = w.author_id WHERE bt1.tag_id IN (SELECT bt.tag_id FROM book AS b JOIN book_tag AS bt ON b.book_id = bt.book_id WHERE b.book_id = '${bookId}' and b.accepted =true)ORDER BY b1.part)
   as my_q where my_row = 1 limit 5;`)

  return res.rows;
}

module.exports.addRatingWithReview = async (bookId, userId, rate, desc) => {
  let res = await pool.query(`INSERT INTO review(book_id,user_id,review_content) VALUES ('${bookId}' , '${userId}' , '${desc}'); INSERT INTO rate(book_id,user_id,rate) VALUES ('${bookId}' , '${userId}' , ${rate});`);

  let result = await pool.query(`SELECT COUNT(*) FROM rate WHERE book_id = '${bookId}'`);
  result = parseInt(result.rows[0].count);
  let prevRate = await pool.query(`SELECT rating FROM book WHERE book_id = '${bookId}'`);
  prevRate = parseInt(prevRate.rows[0].rating);
  let newRate = parseInt((rate + prevRate * result) / (result + 1));
  result = await pool.query(`UPDATE  book SET rating = ${newRate} where book.book_id = '${bookId}'`);

  return res.rows;
}
//cart

module.exports.incompleteOrders = async (userID) => {         //to get incompleted order of a user


  let result = await pool.query(`SELECT o.*,b.* FROM my_order AS o JOIN reader AS r ON r.user_id = o.user_id JOIN book AS b ON b.book_id = o.book_id WHERE o.is_completed = FALSE AND r.user_id = ' ${userID} ';`);
  return result.rows;
}
module.exports.updateOrder = async (orderId, num) => {         //to get incompleted order of a user
  let prevQty = await pool.query(`SELECT qty FROM my_order WHERE order_id = '${orderId}';`);
  if (prevQty.rows[0].qty + num <= 0) { return 0 }
  let result = await pool.query(`update my_order set qty = qty + ${num} where order_id = '${orderId}';`);
  return result.rows;
}

module.exports.DeleteOrder = async (orderId) => {
  let result = await pool.query(`DELETE FROM my_order WHERE order_id = '${orderId}'`);
  return result;
}

module.exports.checkOut = async (userId, total) => {
  await pool.query(`UPDATE reader set balance = ${total}  where user_id = '${userId}'; `)
  let res = await pool.query(`UPDATE my_order SET is_completed = TRUE WHERE user_id = '${userId}' AND is_completed = false;`);

  return res.rows;
}
module.exports.getuserBalance = async (userId) => {

  let res = await pool.query(`select balance from reader where user_id = '${userId}';`);

  return res.rows[0].balance;
}
module.exports.SearchBookByQ = async (Q) => {

  let res = await pool.query(`select b.*, r.username from book as b JOIN (SELECT MAX(w.author_id) AS author_id,w.book_id FROM writes as w GROUP BY w.book_id) AS sub ON sub.book_id = b.book_id JOIN reader as r ON r.user_id = sub.author_id WHERE POSITION(lower('${Q}') in lower(b.title)) > 0 and b.accepted = true;`);
  return res.rows;
}
module.exports.BooksReviews = async (Q) => {

  let res = await pool.query(`SELECT rv.book_id,count(*) from review as rv, reader as rd 
  where rv.user_id = rd.user_id 
  GROUP by book_id;`);

  return res.rows;
}
module.exports.AddtoCart = async (userId, bookId, quantity) => {

  let res = null;
  let checkQuery = await pool.query(`SELECT * FROM my_order WHERE user_id = '${userId}' AND book_id = '${bookId}' AND is_completed = FALSE;`);
  if (checkQuery.rows.length === 0) {
    res = await pool.query(`INSERT INTO my_order (user_id,book_id,qty) VALUES ('${userId}','${bookId}',${parseInt(quantity)})`);
  }
  else {
    res = await pool.query(`UPDATE my_order SET qty = qty + ${parseInt(quantity)} WHERE user_id = '${userId}' AND book_id = '${bookId}' AND is_completed = FALSE;`);
  }
  return res.rows;
}
module.exports.SearchBookByTag = async (tag) => {

  let res = await pool.query(`SELECT * FROM(
    SELECT b.*, r.*,sub1.review_count, ROW_NUMBER() OVER(PARTITION BY b.book_id ORDER BY r.username) AS my_row
    FROM book AS b JOIN writes AS w ON w.book_id = b.book_id JOIN reader AS r ON r.user_id = w.author_id JOIN book_tag as bt ON bt.book_id = b.book_id JOIN tag AS t ON t.tag_id = bt.tag_id JOIN (SELECT b1.book_id AS bID, COUNT(*) AS review_count FROM review as re right JOIN book AS b1 ON re.book_id = b1.book_id GROUP BY b1.book_id) AS sub1 ON sub1.bID = b.book_id WHERE POSITION(lower('${tag}') in lower(t.tag_name)) > 0 AND b.accepted = true) as my_q 
    where my_row = 1;`);
  return res.rows;
}
module.exports.login = async (username) => {
  let res = await pool.query(`SELECT * FROM reader WHERE username = '${username}'`);

  if (res.rows.length === 1) {

    return res.rows
  }
  else {
    return 0;
  }

}


module.exports.signIn = async (username, pass, first, last, type, gender, balance, birth, city, profile, tags) => {

  gender = gender == 'Male' ? true : false;
  let check = await pool.query(`SELECT * FROM reader WHERE username = '${username}'`);
  if (check.rows.length !== 0) {
    console.log('wrong')
    return 0;
  }

  let ins = await pool.query(`insert into reader (username,pass,first_name,last_name,user_type,gender,balance,birthdate,city,profile_pic) VALUES ('${username}','${pass}','${first}','${last}','${type}',${gender},${balance},'${birth}','${city}','${profile}');`);
  let user = await pool.query(`SELECT * FROM reader WHERE username = '${username}';`);
  let userId = user.rows[0].user_id;

  tags = Array.from(tags);
  tags.shift();
  if (Array.isArray(tags)) {
    for (const tag of tags) {

      let tagName = await pool.query(`SELECT tag_id FROM tag WHERE tag_name = '${tag}'`);
      tagName = tagName.rows[0].tag_id;
      let insTag = await pool.query(`insert into user_tag (user_id,tag_id) values ('${userId}','${tagName}');`);
    }
  }
  return user.rows[0];

}

module.exports.userBlogs = async (username) => {

  let res = await pool.query(`SELECT b.*, bk.book_id,bk.title,bk.photo,bk.rating FROM blog AS b JOIN reader AS r ON r.user_id = b.user_id JOIN book AS bk ON b.book_id = bk.book_id WHERE r.username = '${username}' ORDER BY b.date_posted DESC;`);

  return res.rows;
}

module.exports.userTags = async (username) => {

  let res = await pool.query(`SELECT t.tag_name FROM user_tag AS ut JOIN reader AS r ON r.user_id = ut.user_id JOIN tag AS t ON t.tag_id = ut.tag_id WHERE r.username = '${username}';`);

  return res.rows;
}

module.exports.editProfile = async (username, pic, cover, newUsername) => {

  let checkUser = await pool.query(`SELECT username FROM reader WHERE username = '${newUsername}'`)
  checkUser = checkUser.rows.length;
  if (checkUser > 1) {
    return 0;
  }
  let res = await pool.query(`UPDATE reader SET profile_pic = '${pic}',username = '${newUsername}',cover = '${cover}' WHERE username = '${username}' ;`);

  return res.rows;
}

module.exports.AuthorRecentBooks = async (username) => {
  let res = await pool.query(`SELECT * FROM book AS b JOIN writes AS w ON w.book_id = b.book_id JOIN reader AS r ON r.user_id = w.author_id WHERE username = '${username}' AND b.accepted = TRUE ORDER BY b.ate_published DESC LIMIT 6;`);
  return res.rows;
}
module.exports.AuthorBooks = async (username) => {
  let res = await pool.query(`SELECT * FROM book AS b JOIN writes AS w ON w.book_id = b.book_id JOIN reader AS r ON r.user_id = w.author_id WHERE username = '${username}' AND b.accepted = TRUE;`);
  return res.rows;
}
module.exports.bestBooksAuthor = async (username) => {
  let res = await pool.query(`SELECT * FROM book AS b JOIN writes AS w ON w.book_id = b.book_id JOIN reader AS r ON r.user_id = w.author_id WHERE username = '${username}' AND b.accepted = TRUE ORDER BY b.rating LIMIT 4;`);
  return res.rows;
}
module.exports.readerAllBooks = async (username) => {
  let res = await pool.query(`SELECT DISTINCT  b.*,r.* FROM book AS b JOIN my_order as o ON o.book_id = b.book_id JOIN reader AS r ON r.user_id = o.user_id WHERE r.username = '${username}'`);

  return res.rows;
}
module.exports.readerBestBooks = async (username) => {
  let res = await pool.query(`SELECT DISTINCT b.*,r.* FROM book AS b JOIN my_order as o ON o.book_id = b.book_id JOIN reader AS r ON r.user_id = o.user_id WHERE r.username = '${username}' ORDER BY rating DESC LIMIT  4;`);

  return res.rows;
}
module.exports.borrowbooks = async (userId) => {

  let res = await pool.query(`SELECT * FROM reader as r JOIN borrow as bw ON bw.user_id = r.user_id JOIn book as b ON bw.book_id = b.book_id JOIN writes AS w ON w.book_id = b.book_id JOIN reader AS a ON a.user_id = w.author_id WHERE r.user_id = '${userId}';`);
  return res.rows;
}
module.exports.borrowNotReturned = async (userId) => {

  let res = await pool.query(`SELECT * FROM reader as r JOIN borrow as bw ON bw.user_id = r.user_id JOIn book as b ON bw.book_id = b.book_id JOIN writes AS w ON w.book_id = b.book_id JOIN reader AS a ON a.user_id = w.author_id WHERE r.user_id = '${userId}' AND returned = FALSE;`);
  return res.rows;
}
module.exports.borrowReturned = async (userId) => {

  let res = await pool.query(`SELECT * FROM reader as r JOIN borrow as bw ON bw.user_id = r.user_id JOIn book as b ON bw.book_id = b.book_id JOIN writes AS w ON w.book_id = b.book_id JOIN reader AS a ON a.user_id = w.author_id WHERE r.user_id = '${userId}' AND returned = TRUE;`);
  return res.rows;
}
module.exports.returnBook = async (userId, bookId) => {

  let res = await pool.query(`UPDATE borrow SET returned = TRUE WHERE user_id = '${userId}' AND book_id = '${bookId}' AND returned = FALSE;`);
  return res.rows;
}
module.exports.borrowBook = async (userId, bookId) => {         //to get the latest 6 events
  let borrowedBooks = await pool.query(`SELECT count(*) FROM borrow WHERE user_id = '${userId}' AND returned = false`);
  borrowedBooks = borrowedBooks.rows[0].count;

  if (borrowedBooks == 0) {
    let result = await pool.query(`INSERT INTO borrow(user_id,book_id) values ('${userId}','${bookId}');`);
  }
  else {
    return 0;
  }

  return result.rows;
}

module.exports.profileCounts = async (username) => {
  let res = await pool.query(`SELECT COUNT(rev.review_id) AS review_count, (SELECT COUNT(bg.blog_id) FROM blog AS bg JOIN reader AS r ON r.user_id = bg.user_id WHERE r.username = '${username}') AS blog_count FROM review as rev JOIN reader AS r ON r.user_id = rev.user_id WHERE r.username = '${username}';`);

  return res.rows;
}


module.exports.readerRecentBooks = async (username) => {
  let res = await pool.query(`SELECT DISTINCT sub.bkId,title,date_published,description,photo,rating FROM (SELECT *, b.book_id AS bkId FROM reader AS r JOIN my_order AS o ON o.user_id = r.user_id JOIN book AS b ON b.book_id = o.book_id WHERE r.username = '${username}' AND o.is_completed = TRUE ORDER BY assign_date DESC) AS sub LIMIT 6;`);

  return res.rows;
}

module.exports.BooksToApprove = async () => {
  let res = await pool.query(`SELECT b.book_id, b.date_published, b.title,sub.username, b.price from book as b JOIN (SELECT w.book_id, MAX(r2.username) AS username FROM writes AS w JOIN reader AS r2 ON r2.user_id = w.author_id GROUP BY w.book_id) AS sub ON sub.book_id = b.book_id where b.accepted = false;
    `);

  return res.rows;
}
module.exports.TotalIncome = async () => {
  let res = await pool.query(`select sum(total_price) as total_income, now()::date as cur_date, (now()::date-7) last_week_date from
    (select b.title, b.price, sub.qty, (b.price * sub.qty)as total_price from book as b join
    (SELECT o.book_id, qty from my_order as o where is_completed = true and assign_date >= (now()::date - 7) and assign_date <= now()::date ) as sub
    on b.book_id = sub.book_id) as sub2;
    
    `);
  return res.rows[0];

}
module.exports.TotalOrder = async () => {
  let res = await pool.query(`SELECT count(*) as order, now()::date as cur_date, (now()::date - 7) as last_week_date from my_order where is_completed = true and assign_date >= now()::date -7 and assign_date <= now()::date;
    `);
  return res.rows[0];

}


module.exports.TotalUsers = async () => {
  let res = await pool.query(`select count(*) as user_cnt, now()::date as cur_date, (now()::date - 30) as last_week_date from reader where join_date >= (now()::date - 30) and join_date <= now()::date;
     `);
  return res.rows[0];

}

module.exports.TotalBlogs = async () => {
  let res = await pool.query(`SELECT count(*) as blogs_cnt, now()::date as cur_date, (now()::date - 10) as last_week_date from blog where  date_posted >= now()::date -10
    and date_posted <= now()::date;
    `);
  return res.rows[0];

}

module.exports.AcceptBook = async (bookID) => {
  let res = await pool.query(`UPDATE book set accepted = true WHERE book_id = '${bookID}';

    `);
  return res.rowCount;

}
module.exports.DeclineBook = async (bookID) => {
  let res = await pool.query(`DELETE from book WHERE accepted = false and book_id = '${bookID}';

    `);
  return res.rowCount;

}
module.exports.allUsers = async () => {
  let res = await pool.query(`select user_id, username ,first_name, last_name, birthdate,gender , city,balance, profile_pic, cover ,user_type from reader; `);
  return res.rows;

}
module.exports.DeleteUser = async (id) => {
  let res = await pool.query(`delete from reader where user_id = '${id}' and user_type != 'admin';
    `);
  return res.rows;

}
module.exports.SetAdmin = async (id) => {
  let res = await pool.query(` UPDATE  reader set user_type = 'Admin' where user_id = '${id}';`);
  return res.rows;

}
module.exports.totalincomeinmonth = async () => {
  let res = await pool.query(`select sub2.mon, sub2.yyyy, sum(sub2.total_price) as total, count(sub2.mon)as orders_cnt from
    (select b.title, (b.price * sub.qty) as total_price, 
    to_char(sub.assign_date, 'Mon') as mon, EXTRACT(year from sub.assign_date) as yyyy
     from book as b join
    (SELECT o.book_id, qty, assign_date from my_order as o where is_completed = true) as sub
    on b.book_id = sub.book_id) as sub2
    GROUP by sub2.mon, sub2.yyyy
    ORDER by sub2.yyyy desc 
    
    
    `);
  return res.rows;

}
module.exports.addBook = async (userId, sequel, title, price, pic, part, date, chapters, age, desc, others, tags) => {         //tags and others are arrays

  //adding the main data of the book
  let mainBook = await pool.query(`INSERT INTO book (title,price,photo,part,date_published,chapters,age_rating,description) VALUES ('${title}',${price},'${pic}',${part},'${date}',${chapters},${age},'${desc}');`);
  let bookId = await pool.query(`SELECT book_id FROM book WHERE title = '${title}'`);
  bookId = bookId.rows[0].book_id;//get the id of the added book
  if (sequel != '') {
    let addSequel = await pool.query(`UPDATE book SET sequel = '${sequel}' WHERE book_id = '${bookId}';`);//add sequel if exists
  }
  let assignUser = await pool.query(`Insert INTO writes (author_id,book_id) VALUES ('${userId}','${bookId}');`);//assign the book to the main user who added it

  if (Array.isArray(others)) {
    for (const other of others) {
      let otherId = await pool.query(`SELECT user_id FROM reader WHERE username = '${other}'`);
      otherId = otherId.rows[0].user_id;//get the other id

      let assignOther = await pool.query(`INSERT INTO writes (author_id,book_id) VALUES ('${otherId}','${bookId}')`);//assign the book to all authors
    }
  }

  tags = Array.from(tags);
  tags.shift();
  if (Array.isArray(tags)) {
    for (const tag of tags) {

      let tagId = await pool.query(`SELECT tag_id FROM tag WHERE tag_name = '${tag}'`);
      tagId = tagId.rows[0].tag_id;//get the tag id

      let assignTag = await pool.query(`INSERT INTO book_tag (book_id,tag_id) VALUES ('${bookId}','${tagId}');`);//assign the tag to the book

    }
  }

  return mainBook.rows;
}

module.exports.SetuserBalance = async (userId, total) => {

  let res = await pool.query(`UPDATE reader set balance = ${total} where user_id = '${userId}';`);

  return res.rows[0];
}
module.exports.AddEvent = async (loc, tickets, price, title, due_to, des, cover) => {

  let res = await pool.query(`INSERT INTO events(place, tickets, ticket_price, title, due_to, description, event_photo) values('${loc}',${tickets},${price}, '${title}', '${due_to}', '${des}','${cover}');
    `);

  return res.rows;
}
module.exports.AllEvents = async () => {

  let res = await pool.query(`SELECT * from events ORDER BY due_to DESC`);

  return res.rows;
}
module.exports.ChangePassword = async (userId, pass) => {
  let res = await pool.query(`UPDATE reader set pass = '${pass}' where user_id = '${userId}';
    `);

  return res.rows;
}
module.exports.bookTicket = async (eventId, userId) => {
  let check = await pool.query(`select * from go_to where user_id = '${userId}' and event_id = '${eventId}';`)
  if (check.rowCount == 0) {
    let no_ticket = await pool.query(`SELECT tickets,ticket_price from events where event_id = '${eventId}';`)
    let no_tickets = no_ticket.rows[0];
    if (no_tickets.tickets >= 1) {

      let balance = await pool.query(`SELECT balance from reader where user_id='${userId}';`);
      balance = balance.rows[0].balance
      if (balance >= no_tickets.ticket_price) {
        await pool.query(`insert into go_to(event_id, user_id, no_tickets) values('${eventId}', '${userId}', 1)`)
        let newbalance = parseInt(balance - no_tickets.ticket_price)
        await pool.query(` UPDATE reader set balance =${newbalance}  WHERE user_id = '${userId}';`)
        let res = await pool.query(`update events set tickets = tickets - 1 where event_id='${eventId}';`)
        return 1
      }
      return 0;
    }
  }
  return 0;
}
module.exports.getuserType = async (username) => {
  let res = await pool.query(`SELECT user_type FROM reader WHERE username = '${username}';
 `)
  return res.rows[0]
}
module.exports.getuser = async (username) => {
  let res = await pool.query(`SELECT * FROM reader WHERE username = '${username}';`)
  
  return res.rows[0]
}
module.exports.checkEvents = async (userId) => {
  let res = await pool.query(`select event_id from go_to where user_id = '${userId}';`)
  return res.rows
}
//------------------------------------------ test---------------------
module.exports.StatGetDate = async (date) => {

  let res = await pool.query(`SELECT * from stat where vist_date = '${date}';`)
  return res.rowCount
}
module.exports.addStat = async (date) => {
  let res = await pool.query(`insert into stat(vist_date, seconds, no_visits) values('${date}', 0,0) ON CONFLICT (vist_date) DO UPDATE
  SET seconds = EXCLUDED.seconds + stat.seconds,
      no_visits = EXCLUDED.no_visits + stat.no_visits;`)
  return res.rowCount;
}
module.exports.updateStat = async (date, time, vists) => {

  let res = await pool.query(`SELECT sum(no_visits) as no_visits from stat where  vist_date != '${date}'; `)
  
  let lastV = res.rows[0].no_visits;
  let newV = parseInt(vists) - parseInt(lastV);
  await pool.query(`UPDATE stat set seconds = seconds + ${parseInt(time)}, no_visits = ${newV} where vist_date = '${date}';`);

  return res.rows[0];
}

module.exports.pastOrders = async (userId) => {
  let res = await pool.query(`Select b.photo,b.title,sub.authorName,o.assign_date, b.price, o.qty ,(b.price*o.qty) AS total ,b.book_id from my_order AS o JOIN reader AS r ON r.user_id = o.user_id JOIN book AS b ON b.book_id = o.book_id JOIN (SELECT max(r2.username) AS authorName,b2.book_id AS bookId FROM reader AS r2 JOIN writes AS w ON w.author_id = r2.user_id JOIN book AS b2 ON b2.book_id = w.book_id GROUP BY b2.book_id) AS sub ON sub.bookId = b.book_id WHERE o.is_completed = TRUE AND r.user_id = '${userId}' ORDER BY o.assign_date DESC;`);
  return res.rows;
}

module.exports.Getstat = async () => {

  let res = await pool.query('SELECT * from stat order by vist_date  limit 30;');
  return res.rows;
}