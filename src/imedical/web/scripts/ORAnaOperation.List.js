// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


//var ltbl= document.getElementById("tORAnaOperation_List");

//If HStatusVal is "A", then the row is greyed out (to indicate that the operation is cancelled).
//Have to loop through all the tables and pick out the ORAnaOperation_List tables because there can be many instances of this
//table on the one screen.
function BodyLoadHandler() {
	var ltbl, cFlag;
	var arrTbls=document.getElementsByTagName("TABLE");
	for(x=0; x<arrTbls.length; x++) {
		if(arrTbls[x].id == "tORAnaOperation_List"){
			ltbl = arrTbls[x];
			var numRows=ltbl.rows.length;
			for (i=1;i<numRows;i++) {
				var arrfld=ltbl.rows[i].getElementsByTagName('INPUT');
				for (var j=0; j<arrfld.length; j++) {
					if (arrfld[j].id.indexOf("HStatusValz"+i)==0) {
						cFlag=arrfld[j];
						if ((cFlag)&&(cFlag.value=="A")) {
							ltbl.rows[i].className="ORANAOperCancelled";
						}
					}
				}
			}
		}	
	}
}


BodyLoadHandler();

