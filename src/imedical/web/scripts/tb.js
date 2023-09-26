// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//TRAK MENU BAR
//Use filename as a prefix to identify globals and functions

//Show or hide a menu bar option
var regSublevel=/tbi\d+_\d+_\d+/;
function tb_sh(id) {
	var obj=document.getElementById(id);
	if (obj) {
		if (obj.className=='tbihide') {
			//obj.className='tbishow';
			var sublevel="";
			if (regSublevel.test(id)) { sublevel=id.split('_'); sublevel=sublevel[1]; }
			obj.className='tbi'+sublevel+'show';
		} else
			obj.className='tbihide';
	}
}


//highlight toolbar item and display mini toolbar
var tlbar = "";
var tlbarbtn = "";
function tbShowToolbarItems(idbar) {
	var elBar = document.getElementById(idbar);
	var btn = idbar.split("i");
	var id = btn[0] + btn[1];
	var el = document.getElementById(id);
	if ((tlbar != "") && (tlbar != idbar)) {
		document.getElementById(tlbar).style.visibility = "hidden";
		document.getElementById(tlbarbtn).style.border = "";
	}
	if (elBar) {
		if (elBar.style.visibility == "hidden") {
			elBar.style.visibility = "visible";
			elBar.style.display = "";
			tlbar = idbar;
			tlbarbtn = id;


			//--dhcc-- el.style.borderTop = "2px solid buttonhighlight";
			//--dhcc-- el.style.borderRight = "2px solid buttonshadow";
			//--dhcc-- el.style.borderBottom = "2px solid buttonshadow";
			//--dhcc-- el.style.borderLeft = "2px solid buttonhighlight";




                        el.style.borderTop = "0px solid buttonhighlight";
			el.style.borderRight = "0px solid buttonshadow";
			el.style.borderBottom = "0px solid buttonshadow";
			el.style.borderLeft = "0px solid buttonhighlight";






		}
	}
}
