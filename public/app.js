var header = document.getElementsByClassName("sec1")[0];
var deal = document.getElementById("deal");
let lis = Array.from(document.getElementsByTagName("li"));
let show_BOOK = Array.from(document.querySelectorAll("#show_BOOK"));
let mianframe = document.getElementById("mainFrame");
let all = document.getElementById("all");
let flag = true;
var reveals = document.querySelectorAll(".reveal");
window.addEventListener("scroll", () => {
  if (!reveals[reveals.length - 1].classList.contains("active"))
    for (var i = 0; i < reveals.length; i++) {
      var windowheight = window.innerHeight;
      var revealtop = reveals[i].getBoundingClientRect().top;
      var revealpoint = 150;

      if (revealtop < windowheight - revealpoint) {
        reveals[i].classList.add("active");
      }
    }
});

function displayimg(x) {
  let a = Array.from(document.querySelectorAll(`[id='${x}']`));

  a.forEach((e) => {
    e.nextElementSibling.style.display = "block";
  });
  all.style.display = "block";
  all.addEventListener("click", () => {
    a.forEach((e) => {
      e.nextElementSibling.style.display = "none";
    });
    all.style.display = "none";
  });
}
function movetoplace(x) {
  window.location = `#${x}`;
}

function displayimg2(x) {
  let a = document.querySelector(`[id='${x}']`);
  a.nextElementSibling.style.display = "block";
  all.style.display = "block";
  all.addEventListener("click", () => {
    a.nextElementSibling.style.display = "none";
    all.style.display = "none";
  });
}
function movetoplace(x) {
  window.location = `#${x}`;
}
function addbook() {
  window.scrollTo(0, 100);
  all.style.zIndex = 99;
  all.style.display = "block";
  mianframe.style.display = "flex";
  Array.from(show_BOOK).forEach((e) => {
    e.style.display = "none";
  });

  all.addEventListener("click", () => {
    mianframe.style.display = "none";
    all.style.display = "none";
    all.style.zIndex = 5;
  });
}
let dropx = document.getElementById("dropDown");
let user = document.getElementsByClassName("Div_logout")[0];
let oldp = document.getElementById("oldpass");
let newp = document.getElementById("newpass");
let pass = document.getElementById("Changepass");
user.addEventListener("mouseenter", () => {
  if (pass.style.display == "" || pass.style.display == "none")
    dropx.style.display = "flex";
});
dropx.addEventListener("mouseleave", () => {
  dropx.style.display = "none";
  document.getElementById("addmoney").style.display = "none";
});

function checkpass(old) {
  console.log(old);
  axios({
    method: "post",
    url: "https://book-shop-373016.ue.r.appspot.com/checkpassword",
    data: {
      oldpass: old,
    },
    mode: "no-cors",
  }).then((res) => {
    console.log(res);
    if (res.data.ans == 0) {
      oldp.value = "";
      oldp.placeholder = "Wrong Password";
    }
  });
}
function changepass() {
  pass.style.display = "flex";
  dropx.style.display = "none";
  all.style.display = "block";
  all.style.opacity = 0.05;

  all.addEventListener("click", () => {
    pass.style.display = "none";
    all.style.display = "none";
    all.style.opacity = 1;
  });
}
