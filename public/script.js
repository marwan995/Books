let signinTab = document.getElementById("signinTab");
let loginTab = document.getElementById("loginTab");
let signinHeader = document.getElementById("signinH2");
let loginHeader = document.getElementById("hidden");
let signinDiv = document.getElementById("signinSection");
let frame = document.getElementById("inputCont");
let subButton = document.getElementById("subBut");
let form=document.getElementsByTagName('form')[0];
document.signing.action ="/signup";
function toSigninTab() {
    if (loginTab.classList.contains("activeTab")) {
      
        loginTab.classList.toggle("activeTab");
        signinTab.classList.toggle("activeTab");
        loginHeader.classList.toggle("hiddenH2");
        signinHeader.classList.toggle("hiddenH2");
        frame.style.height = "80%";
        subButton.textContent = "Create account";
        setTimeout(() => {
            signinDiv.style.display = "block";
            setTimeout(() => {
                signinDiv.style.opacity = "1";
            }, 10)
        }, 600);
        
        subButton.style.width = "40%";
        document.signing.action ="/signup";
        document.getElementById('Error').style.display='none';
    }
}
let signinBanner= Array.from( document.getElementsByClassName('signinBanner'));
loginTab.addEventListener('click',()=>{
   
    signinBanner[0].style.opacity='1';
})
signinTab.addEventListener('click',()=>{
   
    signinBanner[0].style.opacity='0';
})
function toLoginTab() {
    if (signinTab.classList.contains("activeTab")) 
    {
     

        signinTab.classList.toggle("activeTab");
        loginTab.classList.toggle("activeTab");
        signinHeader.classList.toggle("hiddenH2");
        loginHeader.classList.toggle("hiddenH2");
        console.log(signinHeader.innerText);
        signinDiv.style.opacity = "0";
        setTimeout(() => {
            signinDiv.style.display = "none";
            setTimeout(() => {
                frame.style.height = "50%";
            }, 10)
        }, 600);
        subButton.textContent = "Login";
        subButton.style.width = "25%";
        document.signing.action ="/";
       // setTimeout(()=>{  document.getElementById('Error').style.display='block';},800)
      
    }
}
window.addEventListener('keydown',(e)=>{
    if(e.code=='Enter'){
        subButton.click();
    }
})
