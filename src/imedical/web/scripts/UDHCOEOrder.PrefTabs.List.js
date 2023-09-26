var MAXGROUPS=5;
var itemdataDelim = String.fromCharCode(4);
var groupitemDelim = String.fromCharCode(28);
var tabgroupDelim = String.fromCharCode(1);

var selectedGrp="";var obj=document.getElementById("Add");
if (obj) obj.onclick=AddClickHandler;

for (var j=1; j<6; j++) {
	obj=document.getElementById("LISTGroup"+j);
	if (obj) obj.onclick=ListClickHandler;
}

function ListClickHandler(){
	//if(event.ctrlKey||event.shiftKey)
	var eSrc=websys_getSrcElement();	
	var lst=eSrc;
	window.event.keyCode=99;

}

function 	AddClickHandler(){
	var ary=new Array();
	var n=0;
	var val="";
	var icode="";
	var favItemIDs="";
	var OSItemsWithoutDesc="";
	var OSItemIDInOSArr="";
	
	var maxlimit=MAXGROUPS+1;
	for (var k=1; k<maxlimit; k++) {
		//var arrItems = new Array();
		var lst = document.getElementById("LISTGroup" + k);
		if (lst) {
			for (var i=0; i<lst.options.length; i++) {
				if (lst.options[i].selected==true) {
					var ItemID=lst.options[i].value;
					if (ItemID!=""){
						ary[n]=new Array();
						ary[n]["txt"]=lst.options[i].text;

						arrTemp=ItemID.split(itemdataDelim);
						ItemID=arrTemp[1];
						var Type=arrTemp[0];
						ary[n]["val"]=Type+itemdataDelim+""+itemdataDelim+ItemID;
						n++;
					}
				}
			}
		}
	}
	if ((window.opener)&&(ary.length!=0)){
		window.opener.addSelectedFav(ary);
	}
	window.close();
	//window.setTimeout("Copy_click();",500);
	return true;		
}

