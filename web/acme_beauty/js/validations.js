function CheckClick() {
  alert('1');
}
function alertAction() {
  document.getElementById("alert-overlay").style.display = "none";
}
var month;
var srtmonth;
function getMonth(a, b) {
  month = a;
  srtmonth = b;
  $("button").removeClass("active");
  var element = document.getElementById(a)
  element.classList.add("active");


  if (month == 2) {
    document.getElementById("daysone").style.display = "none";
    document.getElementById("daystwo").style.display = "none";
  }
  else if (month == 1) {
    document.getElementById("daysone").style.display = "block";
    document.getElementById("daystwo").style.display = "block";
  }
  else if (month == 3) {
    document.getElementById("daysone").style.display = "block";
    document.getElementById("daystwo").style.display = "block";
  }
  else if (month == 5) {
    document.getElementById("daysone").style.display = "block";
    document.getElementById("daystwo").style.display = "block";
  }
  else if (month == 7) {
    document.getElementById("daysone").style.display = "block";
    document.getElementById("daystwo").style.display = "block";
  }
  else if (month == 8) {
    document.getElementById("daysone").style.display = "block";
    document.getElementById("daystwo").style.display = "block";
  }
  else if (month == 10) {
    document.getElementById("daysone").style.display = "block";
    document.getElementById("daystwo").style.display = "block";
  }
  else if (month == 12) {
    document.getElementById("daysone").style.display = "block";
    document.getElementById("daystwo").style.display = "block";
  } else {
    document.getElementById("daystwo").style.display = "none";
    document.getElementById("daysone").style.display = "block";
  }
}

function getDate(a, b) {
  var monthlist = ['December', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  var birthday_txt = a;
  var strdates = b;
  var intmonth = parseInt(srtmonth);
  var birthday_txt = monthlist[intmonth] + ' ' + strdates;
  var birthday = strdates + '/' + srtmonth;
  document.getElementById("birthday").setAttribute('value', birthday);
  document.getElementById("birthday_txt").setAttribute('value', birthday_txt);
}
function validateEmail($email) {
  var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
  return emailReg.test($email);
}
function validatemobile_number($mobile_number) {
  var mobile_numberReg = /^(08+[0-9]{8})$/;
  return mobile_numberReg.test($mobile_number);
}
$(document).ready(function () {
  $('#birthday_txt').focus(function () {
    $('#mymodal').modal('show');
  });
});
$(document).ready(function () {
  $('#modalclose').click(function () {
    $('#mymodal').modal('hide');
  });
});
$(document).ready(function () {
  $('#checkmark').click(function () {
    $("#check").attr("checked", true);
  });
});



document.getElementById('form').onsubmit = async function (e) {
  e.preventDefault();
  var error_count = 0;
  // email validations
  if ($("input#email").val() == '') {
    $("#email-alert").html("This field is required.");
    $("#email-alert").addClass("invalid-feedback");
    $("input#email").addClass("is-invalid");

    error_count = error_count + 1;
  } else {
    if (!validateEmail($("input#email").val())) {
      $("#email-alert").html("Invalid Email Address.");
      $("#email-alert").addClass("invalid-feedback");
      $("input#email").addClass("is-invalid");

      error_count = error_count + 1;
    } else {
      $("#email-alert").html("");
      $("#email-alert").removeClass("invalid-feedback");
      $("input#email").removeClass("is-invalid");

    }
  }
  // firstname validations
  if ($("input#fname").val() == '') {
    $("#fname-alert").html("This field is required");
    $("#fname-alert").addClass("invalid-feedback");
    $("input#fname").addClass("is-invalid");
    error_count = error_count + 1;
  } else {
    $("#fname-alert").html("");
    $("#fname-alert").removeClass("invalid-feedback");
    $("input#fname").removeClass("is-invalid");
  }
  // lastname validations 
  if ($("input#lname").val() == '') {
    $("#lname-alert").html("This field is required.");
    $("#lname-alert").addClass("invalid-feedback");
    $("input#lname").addClass("is-invalid");
    error_count = error_count + 1;
  } else {
    $("#lname-alert").html("");
    $("#lname-alert").removeClass("invalid-feedback");
    $("input#lname").removeClass("is-invalid");
  }
  //  Mobile number validations 
  if ($("input#mobile_number").val() == '') {
    $("#mobile_number-alert").html("This field is required.");
    $("#mobile_number-alert").addClass("invalid-feedback");
    $("input#mobile_number").addClass("is-invalid");
    error_count = error_count + 1;
  } else {
    $("#mobile_number-alert").html("");
    $("#mobile_number-alert").removeClass("invalid-feedback");
    $("input#mobile_number").removeClass("is-invalid");
  }
  if (!validatemobile_number($("input#mobile_number").val())) {
    $("#mobile_number-alert").html("Invalid mobile_number number.");
    $("#mobile_number-alert").addClass("invalid-feedback");
    $("input#mobile_number").addClass("is-invalid");
    error_count = error_count + 1;
  } else {
    $("#mobile_number-alert").html("");
    $("#mobile_number-alert").removeClass("invalid-feedback");
    $("input#mobile_number").removeClass("is-invalid");
  }
  // Birthday validations 
  if ($("input#birthday_txt").val() == '') {
    $("#birthday-alert").html("This field is required.");
    $("#birthday-alert").addClass("invalid-feedback");
    $("input#birthday_txt").addClass("is-invalid");
    error_count = error_count + 1;
  } else {
    $("#birthday-alert").html("");
    $("#birthday-alert").removeClass("invalid-feedback");
    $("input#birthday_txt").removeClass("is-invalid");
  }
  if (!$('input[type=checkbox]').prop('checked')) {
    $("#check-alert").html("Please agree to the terms and conditions.");
    $("#check-alert").addClass("invalid-feedback");
    $("#check-alert").show();
    error_count = error_count + 1;
  } if ($('input[type=checkbox]').prop('checked')) {
    $("#check-alert").html("");
    $("#check-alert").removeClass("invalid-feedback");
    $("input#check").removeClass("is-invalid");
  }
  if (error_count == 0) {
      // const store = 'acme_beauty';
      // const endpoint = 'APIGW_URL';
      // const cors = 'https://cors-anywhere.herokuapp.com';
    
      const form = new FormData(this);
      console.log("invalidations : " + form)
      await send_data(form)
      // form.append('company', store);

      // const res = await fetch(cors + '/' + endpoint,
      //   {
      //     method: 'POST',
      //     headers: {
      //       'Content-Type': 'application/json'
      //     },
      //     body: JSON.stringify(Object.fromEntries(form))
      //   }
      // ).then(response => {
      //   if (response.ok) {
      //     window.location.replace('thankyou.html');
      //   }
      // });

  } else {
    error_count = 0;
  }
  return false;
};