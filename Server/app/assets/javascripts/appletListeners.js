var adultSeatStock = gon.adult_seats;
var childSeatStock = gon.child_seats;
var militarySeatStock = gon.military_seats;
var seasonSeatStock = gon.season_seats;
var selectedSeatType = gon.selected_seat;
var transferableSeats = gon.transferable_seats;

var selectedAdults = {};
var selectedChildren = {};
var selectedMilitary = {};
var selectedSeason = {};

var CONFIG=(function(){
  var private = {
         'SEAT_SELECTION_ENABLED': true,
     };
  if(gon.seat_selection_enabled == false){
     private['SEAT_SELECTION_ENABLED']= gon.seat_selection_enabled;
  }
  
  return {
        seatSelectionEnabled: function() { return private['SEAT_SELECTION_ENABLED']; }
    };
})();

function allSeatsSelected(){
  if ((childSeatStock == 0 && adultSeatStock == 0 && militarySeatStock == 0) || seasonSeatStock == 0 ) {
    return true;
  }
  return false;
}

function updateStock(){
  var selectors = document.getElementsByClassName("selector");
  var i = 0;
  for(i=0;i<selectors.length;i++){
    switch(selectors[i].id){
      case "adult":
        selectors[i].innerHTML = "Adult: "+ adultSeatStock;
        break;
      case "child":
        selectors[i].innerHTML = "Child: "+ childSeatStock;
        break;
      case "military":
        selectors[i].innerHTML = "Military: "+ militarySeatStock;
        break;
      case "season":
        
        selectors[i].innerHTML = "Remaining Seats: " + seasonSeatStock;
        break;
    }
  }
  var btn = document.getElementById("purchaseBtn");
  if(btn != null)
  {
    if (allSeatsSelected()){
      btn.disabled = false;
    } else{
      btn.disabled = true; 
    }
  }
}

function initializeReservedSeats(){
  var i = 0;
  var seat;
  if(gon.reserved_seats_concerthall != null)  {
    for(i=0;i<gon.reserved_seats_concerthall.length;i++){
      seat = document.getElementById(""+gon.reserved_seats_concerthall[i].seat_id);
      if(gon.reserved_seats_concerthall[i].seat_id == null){
        seat = document.getElementById(""+gon.reserved_seats_concerthall[i].id);
      }
      if(seat){
        seat.className = "seat reservedSeat";
      }
    }
  }
  if(gon.reserved_seats_playhouse != null)  {
    for(i=0;i<gon.reserved_seats_playhouse.length;i++){
      seat = document.getElementById(""+gon.reserved_seats_playhouse[i].seat_id);
      if(gon.reserved_seats_playhouse[i].seat_id == null){
        seat = document.getElementById(""+gon.reserved_seats_playhouse[i].id);
      }
      if(seat){
        seat.className = "seat reservedSeat";
      }
    }
  }
  
  if(gon.transferable_seats != null){
    for(i=0;i<transferableSeats["adult_seats"].length;i++)
    {
      seat = document.getElementById(transferableSeats["adult_seats"][i].seat_id);
      selectedAdults[seat.id] = "adult";
      seat.className = "seat adultSeat";
    }
    for(i=0;i<transferableSeats["child_seats"].length;i++)
    {
      seat = document.getElementById(transferableSeats["child_seats"][i].seat_id);
      selectedChildren[seat.id] = "child";
      seat.className = "seat childSeat";
    }
    for(i=0;i<transferableSeats["military_seats"].length;i++)
    {
      seat = document.getElementById(transferableSeats["military_seats"][i].seat_id);
      selectedMilitary[seat.id] = "military";
      seat.className = "seat militarySeat";
    }
  }
}
  
function clearSeat(type, e){
  switch (type){
    case "adult":
      delete selectedAdults[e.currentTarget.id];
      break;
    case "child":
      delete selectedChildren[e.currentTarget.id];
      break;
    case "military":
      delete selectedMilitary[e.currentTarget.id];
      break;
    case "season":
      delete selectedSeason[e.currentTarget.id];
      break;
  }
}

$(document).on('click', '.emptySeat', function(e){
  var valid = false;
  if(CONFIG.seatSelectionEnabled() == true){
    switch(selectedSeatType){
      case "adultSeat":
        if(adultSeatStock>0) {
          adultSeatStock--;
          selectedAdults[e.currentTarget.id] = "adult";
          valid = true;
        }
        break;
      case "childSeat":
        if(childSeatStock>0){
          childSeatStock--;
          selectedChildren[e.currentTarget.id] = "child";
          valid = true;
        }
        break;
      case "militarySeat":
        if(militarySeatStock>0){
          militarySeatStock--;
          selectedMilitary[e.currentTarget.id] = "military";
          valid = true;
        }
        break;
      case "seasonSeat":
        if(seasonSeatStock>0){
          seasonSeatStock--;
          selectedSeason[e.currentTarget.id] = "season";
          valid = true;
        }
        break;
    }
  }
  updateStock();
  if(valid){
    e.currentTarget.className="seat "+selectedSeatType;
  }
});

$(document).on('click', '.adultSeat', function(e){
  e.currentTarget.className="seat emptySeat";
  adultSeatStock++;
  clearSeat("adult", e);
  updateStock();
});

$(document).on('click', '.childSeat', function(e){
  e.currentTarget.className="seat emptySeat";
  childSeatStock++;
  clearSeat("child", e);
  updateStock();
});

$(document).on('click', '.militarySeat', function(e){
  e.currentTarget.className="seat emptySeat";
  militarySeatStock++;
  clearSeat("military", e);
  updateStock();
});

$(document).on('click', '.seasonSeat', function(e){
  e.currentTarget.className="seat emptySeat";
  seasonSeatStock++;
  clearSeat("season", e);
  updateStock();
});

function setTheater() {
  var floorplanDiv = document.getElementById("floorplan");
  floorplanDiv.className = gon.theater;
}

function nextTheater() {
  var floorplanDiv = document.getElementById("floorplan");
  floorplanDiv.className = "playhouse";
  seasonSeatStock = gon.season_seats;
  updateStock();
  var concerthallSeatsDiv = document.getElementById("concerthall-seats");
  var playhouseSeatsDiv = document.getElementById("playhouse-seats");
  concerthallSeatsDiv.style.visibility = "hidden";
  playhouseSeatsDiv.style.visibility = "visible";
  var confirmBtn = document.getElementById("purchaseBtn");
  confirmBtn.disabled = true;
  confirmBtn.onclick = function(){ window.location.href = Routes.reserve_seats_season_tickets_path({user_id: gon.user_id, organization_id: gon.organization_id, seats: selectedSeason }); };
}

$(document).on('click', '.selector', function(e){  
  var selectors = document.getElementsByClassName("selectorLI");
  i = 0;
  for (i=0;i<selectors.length;i++)
  {
    selectors[i].className = "selectorLI inactive";
  } 
  e.currentTarget.parentNode.className = "selectorLI active";
  switch(e.currentTarget.id){
    case "adult":
      selectedSeatType = "adultSeat"; 
      break;
    case "child":
      selectedSeatType = "childSeat";
      break;
    case "military":
      selectedSeatType = "militarySeat";
      break;
    case "season":
      selectedSeatType = "seasonSeat";
      break;
  }
});



function purchaseBtn_onclick(url) {
  var urlString = "&";
  var key;
  if(selectedAdults){
    for( key in selectedAdults) {
      if(key != null){
        urlString+= "adultSeats["+key+"]="+selectedAdults[key]+"&";
      }
    }
  }
  if(selectedChildren){
    for( key in selectedChildren) {
      if(key != null){
        urlString+= "childSeats["+key+"]="+selectedChildren[key]+"&";
      }
    }
  }
  if(selectedMilitary){
    for( key in selectedMilitary) {
      if(key != null){
        urlString+= "militarySeats["+key+"]="+selectedMilitary[key]+"&";
      }
    }
  }
  if(selectedSeason){
    for( key in selectedSeason) {
      if(key != null){
        urlString+= "seasonSeats["+key+"]="+selectedSeason[key]+"&";
      }
    }
  }
  window.location.href = url + urlString;
}


