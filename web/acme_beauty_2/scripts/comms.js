const store = 'acme_beauty';
const endpoint = 'APIGW_URL';
const cors = 'https://cors-anywhere.herokuapp.com';
const redirect = "REDIRECT_URL"; // thank-you page to send the visitor to after sign-up

document.getElementById('user-form').onsubmit = async function (e) {
    e.preventDefault();
    // here `this` is the user-form HTML element
    const form = new FormData(this);
    form.append('company' , store);

    const res = await fetch(cors+'/'+endpoint ,
      {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(Object.fromEntries(form))
       }
    ).then( response => {
        if(response.ok){
            window.location.replace(redirect)
        }
    });
};