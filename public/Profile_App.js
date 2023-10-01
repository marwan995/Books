function displayimg(x) {
  let a = document.getElementById(x);
  console.log(a.parentElement.childNodes[3]);
  a.parentElement.childNodes[3].style.display = 'block';
  all.style.display = "block";
  all.addEventListener('click', () => {
      a.parentElement.childNodes[3].style.display = 'none';
      all.style.display = "none";
  })
}
let Commentbtns = Array.from(document.getElementsByClassName('Commentbtn'));
let reactComment = Array.from(document.getElementsByClassName('reactComment'));
let dot = Array.from(document.getElementsByClassName('dot'))
let options = Array.from(document.getElementsByClassName('options'));
let btn2 = document.getElementById('btn2');
let btn = document.getElementById('btn1');
let con = Array.from(document.querySelectorAll('#container'))
let creatcommentForms = Array.from(document.querySelectorAll('#creatCommentForm'))
let editform = Array.from(document.querySelectorAll('#editform'))
let posts = Array.from(document.getElementsByClassName('post'));
let deals = document.getElementById('deals');
let New_Arrivals=document.getElementById('New_Arrivals');
let bookscontent = document.getElementsByClassName('authorBooks')[0];
let sec5 = document.getElementsByClassName('sec5')[0]
deals.addEventListener('click', () => {



  bookscontent.style.display = 'table';
  sec5.style.display = 'none';
  deals.classList.add('blogss');
  deals.classList.remove('bookss')
  New_Arrivals.classList.add('bookss')
  New_Arrivals.classList.remove('blogss');

})
New_Arrivals.addEventListener('click', () => {



  bookscontent.style.display = 'none';
  sec5.style.display = 'block';
  deals.classList.add('bookss');
  deals.classList.remove('blogss')
  New_Arrivals.classList.add('blogss')
  New_Arrivals.classList.remove('bookss');

})
Commentbtns.forEach(btn => {
  btn.addEventListener('click', () => {
      let comments = btn.parentElement.parentElement.childNodes[13];
      if (comments.style.display == 'block')
          comments.style.display = 'none';
      else
          comments.style.display = 'block';
  })
})

dot.forEach(d => {
  d.addEventListener('click', () => {
      d.parentNode.childNodes[3].style.display = 'block';
      d.parentNode.childNodes[3].classList.add('hello')

      window.addEventListener('click', (e) => {

          if (e.target != d && e.target != d.parentElement.childNodes[3].childNodes[3].childNodes[1] && e.target != d.parentElement.childNodes[3].childNodes[3].childNodes[3]) {
              d.parentNode.childNodes[3].style.display = 'none';
              d.parentNode.childNodes[3].classList.remove('hello')
          }
      })
  })
})

creatcommentForms.forEach(ccf => {
  ccf.childNodes[5].addEventListener('click', (e) => {
      if (ccf.childNodes[1].value == '' || ccf.childNodes[3].value == '') {
          e.preventDefault()
      }

  })
})
editform.forEach(ef => {
  ef.childNodes[3].addEventListener('click', (e) => {
      if (ef.childNodes[1].value == '') {
          e.preventDefault()
      }

  })
})

var box = document.getElementsByClassName("file-image")[0];
let box1= document.getElementsByClassName("file-image1")[0]
var fileInp = document.getElementById("inputPostimg");
var fileInp1 = document.getElementById("inputPostimg1");
let all=document.getElementById('all')
let input= document.getElementById('Edittitle');
let flname=document.getElementsByClassName('name')[0].getElementsByTagName('h1')[0]
let cover=  document.getElementsByClassName('sec1')[0].style.backgroundImage

document.getElementById('editpfp').addEventListener('click', () => {
    scrollTo(0,0)
    let fileimage = document.getElementsByClassName('file-image')[0];
    let fileimage1 = document.getElementsByClassName('file-image1')[0];
    input.style.display='block'
    input.value=flname.style.display!='none'?flname.innerText:'';
    flname.style.display='none'
    input.focus()
    fileimage.style.opacity = 1
    fileimage1.style.opacity = 1
    document.getElementById('imageUrl').value=document.getElementById('pfp').src
    document.getElementById('imageUrl1').value=window.getComputedStyle(document.querySelector('.sec1')).backgroundImage.slice(5,-2)
       document.querySelectorAll('#SubmitEdit').forEach(e=>e.style.display='inline-block')
    box.addEventListener('click', () => {
        if(  fileimage1.style.opacity ==1)
        fileInp.click();
    })
    box1.addEventListener('click', () => {
        if(  fileimage1.style.opacity ==1)
        fileInp1.click();
    })

})

var loadFile = async function (event) {

    var image = document.getElementById('uploadedImg');
    var tempimg = document.getElementById('tempimg');
    let fileimage = document.getElementsByClassName('file-image')[0];
    let cover= document.getElementsByClassName('sec1')[0].style.backgroundImage
    fileimage.getElementsByTagName('p')[0].style.opacity = 0
    fileimage.getElementsByTagName('img')[1].style.opacity = 0
    
console.log('here')

    image.style.opacity = 1
    fileimage.style.border = 'none'
    var file = document.getElementById('inputPostimg');
    var form = new FormData();
    form.append("image", file.files[0])
    var settings = {
        "url": "https://api.imgbb.com/1/upload?key=b79ad1c2e8b9883bd4de5f26d5b427bd",
        "method": "POST",
        "timeout": 0,
        "processData": false,
        "mimeType": "multipart/form-data",
        "contentType": false,
        "data": form
    };

    image.src = '../loading.gif';
    let x = await axios(settings)
    document.getElementById('imageUrl').value = x.data.data.display_url
    image.src = x.data.data.display_url
};

var loadcover = async function (event) {

   
    var image1 = document.getElementById('uploadedImg1');
    var tempimg1 = document.getElementById('tempimg1');
    let fileimage1 = document.getElementsByClassName('file-image1')[0];
   
    fileimage1.style.opacity = 1

    fileimage1.getElementsByTagName('p')[0].style.opacity = 0
    fileimage1.getElementsByTagName('img')[1].style.opacity = 0

    image1.style.opacity = 1


    fileimage1.style.border = 'none'
    var file1 = document.getElementById('inputPostimg1');
    var form1 = new FormData();
    form1.append("image", file1.files[0])
    var settings1 = {
        "url": "https://api.imgbb.com/1/upload?key=b79ad1c2e8b9883bd4de5f26d5b427bd",
        "method": "POST",
        "timeout": 0,
        "processData": false,
        "mimeType": "multipart/form-data",
        "contentType": false,
        "data": form1
    };
    image1.src = '../loading2.gif';

    let x1 = await axios(settings1)
    console.log(x1)

    document.getElementById('imageUrl1').value = x1.data.data.display_url
   
    document.getElementsByClassName('sec1')[0].style.backgroundImage= `url(${x1.data.data.display_url})`
    image1.style.display='none'
    fileimage1.style.opacity = 0



};
function Cancel(){
input.style.display='none'
flname.style.display='block'
document.getElementsByClassName('sec1')[0].style.backgroundImage=cover
box1.style.opacity=0
box.style.opacity=0
document.querySelectorAll('#SubmitEdit').forEach(e=>e.style.display='none')


}
function edit(){
document.getElementById('x').submit() 
location.reload()
}
function viewbook(x) {
    window.location.href = `/book/${x}`

}

let dropx = document.getElementById('dropDown');
let user = document.getElementsByClassName('Div_logout')[0]
let oldp = document.getElementById('oldpass');
let newp = document.getElementById('newpass');
let pass=document.getElementById('Changepass');

user.addEventListener('mouseenter', () => {
  if(pass.style.display==''||pass.style.display=='none')
  dropx.style.display = 'flex'
})
dropx.addEventListener('mouseleave', () => {
  dropx.style.display = 'none'
  document.getElementById('addmoney').style.display = 'none'
})


function checkpass(old) {
  console.log(old)
  axios({
    method: 'post',
    url: 'https://book-shop-373016.ue.r.appspot.com/checkpassword',
    data: {
      oldpass: old
    }, mode: "no-cors"
  }).then(res => {
    console.log(res)
    if (res.data.ans == 0) {
      oldp.value = '';
      oldp.placeholder = 'Wrong Password'
    }

  })

}
function changepass() {
pass.style.display='flex'
dropx.style.display = 'none'
  all.style.display='block'
  all.style.opacity=.05


  all.addEventListener('click',()=>{
    pass.style.display='none'
    all.style.display='none'
    all.style.opacity=1

  })
}

function addbook(){
  let show_BOOK = Array.from(document.querySelectorAll("#show_BOOK"));
let mianframe=document.getElementById('mainFrame')
let all = document.getElementById("all");
window.scrollTo(0, 100);
all.style.zIndex=99
all.style.display='block'
mianframe.style.display='flex'
Array.from(show_BOOK).forEach(e=>{e.style.display='none'});

all.addEventListener('click',()=>{
mianframe.style.display='none'
all.style.display='none'
all.style.zIndex=5

})
}