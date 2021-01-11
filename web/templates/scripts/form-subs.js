const store = '';
const endpoint = ''

document.getElementById('user-form').onsubmit = async function (e) {
    e.preventDefault();
    // here `this` is the user-form HTML element
    const form = new FormData(this);
    form.append('store' , store);
    console.log("attempting post....")
    data = { "firstname" : "kyle", "lastname" : "ruby"}
    const res = await fetch(,
      {
            method: 'POST',
            mode: 'no-cors',
            headers: {
              'content-type': 'application/json'
            },
            body: JSON.stringify(data)
       }
    );

    console.log("Failed here : " + res);
};


