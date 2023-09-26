// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


f=document.fEPVisitNumber_ClinicWorkList_Preferences;

var DFChange,DTChange,DFOffset,DTOffset,DFCurrent,DTCurrent,DFInit,DTInit,DFFinal,DTFinal="";

var DFOObj=document.getElementById("WIPDtFromOffset");
var DTOObj=document.getElementById("WIPDtToOffset");
var DFCObj=document.getElementById("WIPDateFromToday");
var DTCObj=document.getElementById("WIPDateToToday");

function DocumentLoadHandler()
{
/*
  var obj=document.getElementById("Params");
  if (obj) {
	  var arrparam = obj.value.split("^");
	  if (arrparam.length > 14) {
		var obj=document.getElementById("WIPDateFromToday");
  		if (obj) {
			if (arrparam[0]==1) {
				obj.checked = true;
			} else {
				obj.checked = false;
			}
		}
		var obj=document.getElementById("WIPDtFromOffset");
  		if (obj) obj.value = arrparam[1];
		var obj=document.getElementById("WIPDateToToday");
  		if (obj) {
			if (arrparam[2]==1) {
				obj.checked = true;
			} else {
				obj.checked = false;
			}
		}
		var obj=document.getElementById("WIPDtToOffset");
  		if (obj) obj.value = arrparam[3];
  		var objList = document.getElementById("WIPEpisodeTypeList");
  		if (objList) obj.value = arrparam[4];
  		var objList = document.getElementById("WIPHospitalList");
  		if (objList) obj.value = arrparam[5];
  		var objList = document.getElementById("WIPCPList");
  		if (objList) obj.value = arrparam[6];
  		var objList = document.getElementById("WIPSpecialtyList");
  		if (objList) obj.value = arrparam[7];
  		var objList = document.getElementById("WIPLocList");
  		if (objList) obj.value = arrparam[8];
  		var objList = document.getElementById("WIPOrderCatList");
  		if (objList) obj.value = arrparam[9];
  		var objList = document.getElementById("WIPOrderSubCatList");
  		if (objList) obj.value = arrparam[10];
  		var objList = document.getElementById("WIPResultStatus");
  		if (objList) obj.value = arrparam[11];
  		var objList = document.getElementById("WIPOrderStatus");
  		if (objList) obj.value = arrparam[12];
  		var objList = document.getElementById("WIPPrio");
  		if (objList) obj.value = arrparam[13];
  		var objList = document.getElementById("WIPOrderingCP");
  		if (objList) obj.value = arrparam[14];
  		var objList = document.getElementById("WIPClinic");
  		if (objList) obj.value = arrparam[15];

	  }
  }
*/
	var obj = document.getElementById("deleteCPs");
	if (obj) obj.onclick = DeleteCPClickHandler;
	var obj = document.getElementById("deleteHosps");
	if (obj) obj.onclick = DeleteHospClickHandler;
	var obj = document.getElementById("deleteSpecs");
	if (obj) obj.onclick = DeleteSpecClickHandler;
	var obj = document.getElementById("deleteLocs");
	if (obj) obj.onclick = DeleteLocClickHandler;
	var obj = document.getElementById("deleteWards");
	if (obj) obj.onclick = DeleteWardClickHandler;
	var obj = document.getElementById("deleteOrdCats");
	if (obj) obj.onclick = DeleteOrdCatClickHandler;
	var obj = document.getElementById("deleteOrdSubCats");
	if (obj) obj.onclick = DeleteOrdSubCatClickHandler;
	var obj = document.getElementById("deleteResStats");
	if (obj) obj.onclick = DeleteResStatClickHandler;
	var obj = document.getElementById("deleteOrdStats");
	if (obj) obj.onclick = DeleteOrdStatClickHandler;
	var obj = document.getElementById("deletePrios");
	if (obj) obj.onclick = DeletePrioClickHandler;
	var obj = document.getElementById("deleteUnits");
	if (obj) obj.onclick = DeleteUnitClickHandler;
	var obj = document.getElementById("deleteBeds");
	if (obj) obj.onclick = DeleteBedClickHandler;
	var obj = document.getElementById("deleteRooms");
	if (obj) obj.onclick = DeleteRoomClickHandler;
	var obj = document.getElementById("deleteAdminStats");
	if (obj) obj.onclick = DeleteAdminStatsClickHandler;
	var obj = document.getElementById("deleteAdminRoutes");
	if (obj) obj.onclick = DeleteAdminRoutesClickHandler;
    var obj = document.getElementById("deleteRecLocs");
	if (obj) obj.onclick = DeleteRecLocsClickHandler;

	// get the default from EITHER:
	//  preferences if they exist, or if not,
	//  worklist defaults
	GetDefaults();
    disableFields();

	var obj=document.getElementById("WIPDateToToday");
	if (obj) obj.onclick=disableFields;

	var obj=document.getElementById("WIPDateFromToday");
	if (obj) obj.onclick=disableFields;

	var obj=document.getElementById("WIPLogonCP");
	if (obj) obj.onclick=disableFields;
	var objList = document.getElementById("WIPCPList");
	var objlistbox = document.getElementById("CPs");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var obj=document.getElementById("WIPLogonHosp");
	if (obj) obj.onclick=disableFields;

	var objList = document.getElementById("WIPHospitalList");
	var objlistbox = document.getElementById("Hosps");
	if (objList) {
	  if (objlistbox) AddAllItemsToList(objlistbox, objList.value);
      
	}

	var objList = document.getElementById("WIPUnitList");
	var objlistbox = document.getElementById("Units");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var obj=document.getElementById("WIPLogonSpecialty");
	if (obj) obj.onclick=disableFields;
	var objList = document.getElementById("WIPSpecialtyList");
	var objlistbox = document.getElementById("Specs");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var obj=document.getElementById("WIPLogonLoc");
	if (obj) obj.onclick=disableFields;
	var objList = document.getElementById("WIPLocList");
	var objlistbox = document.getElementById("Locs");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var objList = document.getElementById("WIPWardList");
	var objlistbox = document.getElementById("Wards");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var objList = document.getElementById("WIPOrderCatList");
	var objlistbox = document.getElementById("OrdCats");
	if (objList && objlistbox) {
	AddAllItemsToList(objlistbox, objList.value);
	}

	var objList = document.getElementById("WIPOrderSubCatList");
	var objlistbox = document.getElementById("OrdSubCats");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}
	var objList = document.getElementById("WIPResultStatus");
	var objlistbox = document.getElementById("ResStats");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}
	var objList = document.getElementById("WIPOrderStatus");
	var objlistbox = document.getElementById("OrdStats");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}
	var objList = document.getElementById("WIPPrioList");
	var objlistbox = document.getElementById("Prios");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var objList = document.getElementById("WIPBedList");
	var objlistbox = document.getElementById("Beds");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var objList = document.getElementById("WIPRoomList");
	var objlistbox = document.getElementById("Rooms");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}

	var objList = document.getElementById("WIPAdminStatsList");
	var objlistbox = document.getElementById("AdminStats");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}
    
	var objList = document.getElementById("WIPAdminRoutesList");
	var objlistbox = document.getElementById("AdminRoutes");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}
    
	var objList = document.getElementById("WIPRecLocsList");
	var objlistbox = document.getElementById("RecLocs");
	if (objList && objlistbox) {
	  AddAllItemsToList(objlistbox, objList.value);
	}    

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;


	/*var objOrdersList=document.getElementById("OrdersList");
	var objResultList=document.getElementById("ResultList");
	var listtype = document.getElementById("WIPClinicListType");
	if (listtype) {
		if (listtype.value == "O") {
			if (objOrdersList) objOrdersList.click();
		} else {
			if (objResultList) objResultList.click();
		}
	}*/

	var objOutPat=document.getElementById("EpisodeOutPat");
	var objInPat=document.getElementById("EpisodeInPat");
	var objEmerPat = document.getElementById("EpisodeEmerPat");
	var objEpisType = document.getElementById("WIPEpisodeTypeList");
	if ( objEpisType ) {
		if (objOutPat && (objEpisType.value.indexOf("O") != -1)) objOutPat.checked = true;
		if (objInPat && (objEpisType.value.indexOf("I") != -1)) objInPat.checked = true;
		if (objEmerPat && (objEpisType.value.indexOf("E") != -1)) objEmerPat.checked = true;
	}

	SetDateVal();
	FlagListboxes();
	PopulateOrderCatCodes();
	PopulateWardIDs();
    
	var obj=document.getElementById("SaveAsHidden");
	if (obj) SetOrgFavSaveAs(obj.value,1);
	
	return;
}

function AddAllItemsToList(obj, list) {
	var tmp = list.split(String.fromCharCode(1));
    var desc="";
    var code="";
	for (var pce=0; pce < tmp.length; pce ++) {
		var strings = tmp[pce].split(String.fromCharCode(2));
		//alert(strings[1] + '\n'+ strings[0]);
		if (strings.length > 1) {
            desc=strings[1].split(",");
            code=strings[0].split(",");
            // ab 1.04.03 - 51121 - replaces \54 codes with commas
	    // ab 9.08.06 - 60304 - \54 incorrectly replaces '4' and '5' characters, changed to control code 3
            for (var pce2=0;pce2<desc.length;pce2++) {
                //desc[pce2]=desc[pce2].replace(/\\54/g,",");
                //code[pce2]=code[pce2].replace(/\\54/g,",");
		// no idea how to do control codes in reg expressions, so just split and join
		descary=desc[pce2].split(String.fromCharCode(3));
		desc[pce2]=descary.join(",");
		codeary=code[pce2].split(String.fromCharCode(3));
		code[pce2]=codeary.join(",");
            }
            AddItemToList(obj, desc, code);
        }
	}
}

function UpdateHandler()
{
	/*var objOrdersList=document.getElementById("OrdersList");
	var objResultList=document.getElementById("ResultList");
	var listtype = document.getElementById("WIPClinicListType");
	if ( objOrdersList && objResultList && listtype ) {
		if (objOrdersList.checked) {
			listtype.value = "O";
		} else {
			listtype.value = "R";
		}
	}*/

	var objOutPat=document.getElementById("EpisodeOutPat");
	var objInPat=document.getElementById("EpisodeInPat");
	var objEmerPat = document.getElementById("EpisodeEmerPat");
	var objEpisType = document.getElementById("WIPEpisodeTypeList");
	if ( objEpisType ) {
		objEpisType.value = "";
		if (objOutPat && (objOutPat.checked)) objEpisType.value = objEpisType.value + "O";
		if (objInPat && (objInPat.checked)) objEpisType.value = objEpisType.value + "I";
		if (objEmerPat && (objEmerPat.checked)) objEpisType.value = objEpisType.value + "E";
		//if (objEpisType.value == "") {
		//	alert("No episode types have been selected");
		//	return false;
		//}
	}

	var objlist = f.CPs;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPCPList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
	}

	var objlist = f.Hosps;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPHospitalList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
	}

	var objlist = f.Units;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPUnitList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
		}

	var objlist = f.Specs;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPSpecialtyList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
	}

	var objlist = f.Locs;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPLocList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.Wards;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPWardList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
	}

	var objlist = f.OrdCats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPOrderCatList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
		}

	var objlist = f.OrdSubCats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPOrderSubCatList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
		}

	var objlist = f.ResStats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPResultStatus");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
		}

	var objlist = f.OrdStats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPOrderStatus");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
		//alert(objWIP.value);
	}
	var objlist = f.Prios;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPPrioList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.Rooms;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPRoomList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.Beds;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPBedList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.AdminStats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPAdminStatsList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.AdminRoutes;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPAdminRoutesList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.RecLocs;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPRecLocsList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	TestDateVal();

	if(checkMandatory()) return update1_click();
}

function returnValuesWithDescriptions(obj) {
	var ary=new Array();
	for (var i=0; i<obj.length; i++) ary[i]=obj.options[i].value + String.fromCharCode(2)+ obj.options[i].text;
	return ary;
}

function checkMandatory()
{
	var msg="";

	if (msg != "") {
		alert(msg);
		return false;
	} else {
		return true;
	}

}



function disableFields(e)
{

	//var objOrdersList=document.getElementById("OrdersList");
	//var objResultList=document.getElementById("ResultList");
	var objWIPDateToToday=document.getElementById("WIPDateToToday");
	var objWIPDateFromToday=document.getElementById("WIPDateFromToday");
	var objWIPDtToOffset=document.getElementById("WIPDtToOffset");
	var objWIPDtFromOffset=document.getElementById("WIPDtFromOffset");
	var objWIPLogonCP=document.getElementById("WIPLogonCP");
	var objCPs=document.getElementById("CPs");
	var objCP=document.getElementById("CP");
	var objWIPLogonHosp=document.getElementById("WIPLogonHosp");
	var objHospital=document.getElementById("Hospital");
	var objHosps=document.getElementById("Hosps");

	var objWIPLogonSpec=document.getElementById("WIPLogonSpecialty");
	var objSpecialty=document.getElementById("Specialty");
	var objSpecs=document.getElementById("Specs");

	var objWIPLogonLoc=document.getElementById("WIPLogonLoc");
	var objLocation=document.getElementById("Location");
	var objLocs=document.getElementById("Locs");

	var objClinicListType=document.getElementById('WIPClinicListType');

	// make Ward mandatory, and disable the date prompts
	if (objClinicListType) {
		if (objClinicListType.value=="O") {
			EnableField("OrderStatus");
			EnableLookup("ld1896iOrderStatus");

			EnableField("OrderSubCat");
			EnableLookup("ld1896iOrderSubCat");

			EnableField("OrderCat");
			EnableLookup("ld1896iOrderCat");

			//log 65892 - KB This has been commented out so that these can be set to display only or Read only in layout editor
			//EnableField("EpisodeOutPat");
			//EnableField("EpisodeInPat");
			//EnableField("EpisodeEmerPat");

			EnableField("WIPLogonCP");
			EnableField("CP");
			EnableLookup("ld1892iCP");

			EnableField("WIPLogonHosp");
			EnableField("Hospital");
			EnableLookup("ld1892iHospital");

			EnableField("WIPLogonLoc");
			EnableField("Location");
			EnableLookup("ld1892iLocation");

			EnableField("WIPLogonSpecialty");
			EnableField("Specialty");
			EnableLookup("ld1892iSpecialty");

			DisableField("ResultStatus");
			DisableLookup("ld1892iResultStatus");
			var obj = document.getElementById("ResStats");
			if (obj) ClearAllList(obj);
		} else if (objClinicListType.value=="R") {

			//log 65892 - KB This has been commented out so that these can be set to display only or Read only in layout editor
			//EnableField("EpisodeOutPat");
			//EnableField("EpisodeInPat");
			//EnableField("EpisodeEmerPat");

			EnableField("WIPLogonCP");
			EnableField("CP");
			EnableLookup("ld1892iCP");

			EnableField("WIPLogonHosp");
			EnableField("Hospital");
			EnableLookup("ld1892iHospital");

			EnableField("WIPLogonLoc");
			EnableField("Location");
			EnableLookup("ld1892iLocation");

			EnableField("WIPLogonSpecialty");
			EnableField("Specialty");
			EnableLookup("ld1892iSpecialty");

			EnableField("ResultStatus");
			EnableLookup("ld1892iResultStatus");

			DisableField("OrderStatus");
			DisableLookup("ld1896iOrderStatus");
			var obj = document.getElementById("OrdStats");
			if (obj) ClearAllList(obj);

			EnableField("OrderSubCat");
			EnableLookup("ld1896iOrderSubCat");

			EnableField("OrderCat");
			EnableLookup("ld1896iOrderCat");

		} else if (objClinicListType.value=="N") {
			//DisableField("WIPDateFromToday");
			//DisableField("WIPDateToToday");
			//DisableField("WIPDtFromOffset");
			//DisableField("WIPDtToOffset");
			DisableField("EpisodeInPat");
			DisableField("EpisodeOutPat");
			DisableField("EpisodeEmerPat");
			var obj=document.getElementById("WardCodes");
			/*
			if (obj && (obj.value=="")) {
					DisableField("Bed");
					DisableLookup("ld1892iBed");
					var objlist = document.getElementById("Beds");
					if (objlist) ClearAllList(objlist);
					DisableField("Room");
					DisableLookup("ld1892iRoom");
					var objlist = document.getElementById("Rooms");
					if (objlist) ClearAllList(objlist);
			}
			*/
		}

	}


 	if (objWIPDateToToday) {
		if (objWIPDateToToday.checked==true) {
 			DisableField("WIPDtToOffset");
		} else {
			EnableField("WIPDtToOffset");
		}
 	}

 	if (objWIPDateFromToday) {
		if (objWIPDateFromToday.checked==true) {
 			DisableField("WIPDtFromOffset");
		} else {
			EnableField("WIPDtFromOffset");
		}
 	}

	if (objWIPLogonCP) {
		if (objWIPLogonCP.checked) {
			DisableField("CP");
			DisableLookup("ld1892iCP");
			var obj = document.getElementById("CPs");
			if (obj) ClearAllList(obj);
		} else {
			EnableField("CP");
			EnableLookup("ld1892iCP");
		}
	}

	if (objWIPLogonHosp) {
		if (objWIPLogonHosp.checked) {
			DisableField("Hospital");
			DisableLookup("ld1892iHospital");
			var obj = document.getElementById("Hosps");
			if (obj) ClearAllList(obj);
		} else {
			EnableField("Hospital");
			EnableLookup("ld1892iHospital");
		}
	}

	if (objWIPLogonSpec) {
		if (objWIPLogonSpec.checked) {
			DisableField("Specialty");
			DisableLookup("ld1892iSpecialty");
			var obj = document.getElementById("Specs");
			if (obj) ClearAllList(obj);
		} else {
			EnableField("Specialty");
			EnableLookup("ld1892iSpecialty");
		}
	}

	if (objWIPLogonLoc) {
		if (objWIPLogonLoc.checked) {
			DisableField("Location");
			DisableLookup("ld1892iLocation");
			var obj = document.getElementById("Locs");
			if (obj) ClearAllList(obj);
		} else {
			EnableField("Location");
			EnableLookup("ld1892iLocation");
		}
	}
	return;
}

function TransferCodeToList (obj, str) {
	// swap pieces 2 and 3
	var txt = str.split("^");
	if (txt.length>1) {
		var newstring = txt[0] + "^" + txt[2];
		TransferToList(obj, newstring);
	}

}

/*
function LookUpCP(val) {
f.CP.value="";
TransferToList(f.CPs,val)
}
*/

function LookUpCP(txt) {
    var adata=txt.split("^");
    var idesc=adata[0];
    var icode=adata[1];
    f.CP.value="";
    AddItemToList2(f.CPs,idesc,icode);
    //ClearField();
}

function AddItemToList2(obj,desc,code) {
    if (obj) {
        // ab - don't add if it already exists
        for (var i=0;i<obj.length;i++) {
            if (obj[i].value==code) return false;
        }
        obj.selectedIndex = -1;
        obj.options[obj.length] = new Option(desc,code);
    }
}


function LookUpHosp(val) {
	var txt = val.split("^");
	f.Hospital.value="";
	//TransferCodeToList(f.Hosps,val)
    // ab 18.05.05 52275 - pass code here instead of id
    AddItemToList2(f.Hosps,txt[0],txt[2]);

	var obj=document.getElementById("HospIDs");
	if (obj) {
		if (obj.value!="") obj.value=obj.value+"|";
		obj.value=obj.value+txt[1];
	}
}

function LookUpUnit(val) {
	f.Unit.value="";
	var txt = val.split("^");
    AddItemToList2(f.Units,txt[0],txt[1]);
    
	//if (txt.length>1) {
	//	var newstring = txt[1] + "^" + txt[0];
	//	TransferToList(f.Units, newstring);
	//}
}

function LookUpSpec(val) {
	f.Specialty.value="";
	//TransferCodeToList(f.Specs,val)
	var txt = val.split("^");
    AddItemToList2(f.Specs,txt[0],txt[2]);    
}

function LookUpLoc(val) {
	var txt = val.split("^");
	f.Location.value="";
    AddItemToList2(f.Locs,txt[1],txt[0]);
    //var newstring = txt[1] + "^" + txt[0];
	//TransferToList(f.Locs, newstring);
	//TransferCodeToList(f.Locs,val)

	var obj=document.getElementById("LocIDs");
	if (obj) {
		if (obj.value!="") obj.value=obj.value+"|";
		obj.value=obj.value+txt[3];
	}
	GetLocAndWardIDs();
}

function LookUpOrdCat(val) {
    var txt = val.split("^");
    AddItemToList2(f.OrdCats,txt[0],txt[2]);
	f.OrderCat.value="";
	//TransferCodeToList(f.OrdCats,val)
    PopulateOrderCatCodes();
}

// ab 28.06.05 - 53545
function PopulateOrderCatCodes() {
    var objlist=document.getElementById("OrdCats");
    var obj=document.getElementById("OrderCatCodes");
    if ((obj)&&(objlist)) {
        obj.value="";
        for (var i=0;i<objlist.length;i++) {
            if (obj.value!="") obj.value=obj.value+"^";
            obj.value=obj.value+objlist.options[i].value;
        }
        //alert(obj.value);
    }
}

function LookUpOrderSubCat(val) {
	f.OrderSubCat.value="";
    var txt = val.split("^");
    AddItemToList2(f.OrdSubCats,txt[0],txt[2]);    
	//TransferCodeToList(f.OrdSubCats,val)
}

function LookUpResStat(val) {
	f.ResultStatus.value="";
    var txt = val.split("^");
    AddItemToList2(f.ResStats,txt[0],txt[1]);        
	//TransferCodeToList(f.ResStats,val)
}

function LookUpOrdStat(val) {
	f.OrderStatus.value="";
    var txt = val.split("^");
    AddItemToList2(f.OrdStats,txt[0],txt[2]);    
	//TransferCodeToList(f.OrdStats,val)
}

function LookUpPrio(val) {
	f.Prio.value="";
    var txt = val.split("^");
    AddItemToList2(f.Prios,txt[0],txt[2]);
	//TransferCodeToList(f.Prios,val);
}

function LookUpWard(val) {
	var txt = val.split("^");
	f.Ward.value="";

    AddItemToList2(f.Wards,txt[0],txt[1]);     

	var obj=document.getElementById("WardCodes");
	if (obj) {
		EnableField("Bed");
		EnableLookup("ld1896iBed");
		EnableField("Room");
		EnableLookup("ld1896iRoom");
	}
	var obj=document.getElementById("WardLocIDs");
	if (obj) {
		if (obj.value!="") obj.value=obj.value+"|";
		obj.value=obj.value+txt[4];
	}
	GetLocAndWardIDs();
    PopulateWardIDs();
}

function PopulateWardIDs() {
    var obj=document.getElementById("WardCodes");
    var objlist=document.getElementById("Wards");
    if ((obj)&&(objlist)) {
        obj.value="";
        for (var i=0;i<objlist.length;i++) {
            if (obj.value!="") obj.value=obj.value+"|";
            obj.value=obj.value+objlist.options[i].value;
        }
        //alert(obj.value);
    }
    
}

function LookUpBed(val) {
	var txt = val.split("^");
	f.Bed.value="";
    AddItemToList2(f.Beds,txt[0],txt[3]);
    //var newstring = txt[0] + "^" + txt[3];
	//TransferToList(f.Beds,newstring)
}

function LookUpRoom(val) {
	var txt = val.split("^");
	f.Room.value="";
    AddItemToList2(f.Rooms,txt[0],txt[3]);
    //var newstring = txt[0] + "^" + txt[2];
	//TransferToList(f.Rooms,newstring)
}

function LookUpAdminStats(val) {
	var txt = val.split("^");
	f.AdminStatus.value="";
    AddItemToList2(f.AdminStats,txt[0],txt[1]);
	//TransferToList(f.AdminStats,val)
}

function LookUpAdminRoutes(val) {
	var txt = val.split("^");
	f.AdminRoute.value="";
    AddItemToList2(f.AdminRoutes,txt[0],txt[1]);
}

function LookUpRecLocs(val) {
	var txt = val.split("^");
	f.RecLoc.value="";
    AddItemToList2(f.RecLocs,txt[0],txt[1]);
}

function DeleteAdminStatsClickHandler(e) {
	ClearSelectedList(f.AdminStats);
	return false;
}

function DeleteAdminRoutesClickHandler(e) {
	ClearSelectedList(f.AdminRoutes);
	return false;
}

function DeleteRecLocsClickHandler(e) {
	ClearSelectedList(f.RecLocs);
	return false;
}


function DeleteCPClickHandler(e) {
	if (f.CPs) ClearSelectedList(f.CPs);
	return false;
}

function DeleteUnitClickHandler(e) {
	if (f.Units) ClearSelectedList(f.Units);
	return false;
}

function DeleteHospClickHandler(e) {
	var obj=document.getElementById("HospIDs");
	if (obj) DeleteFromIdString(f.Hosps,obj)

	if (f.Hosps) ClearSelectedList(f.Hosps);
	return false;
}

function DeleteSpecClickHandler(e) {
	if (f.Specs) ClearSelectedList(f.Specs);
	return false;
}

function DeleteLocClickHandler(e) {
	var obj=document.getElementById("LocIDs");
	if (obj) DeleteFromIdString(f.Locs,obj)

	if (f.Locs) ClearSelectedList(f.Locs);
	return false;
}

function DeleteOrdCatClickHandler(e) {
	if (f.OrdCats) ClearSelectedList(f.OrdCats);
    PopulateOrderCatCodes();
	return false;
}

function DeleteOrdSubCatClickHandler(e) {
	if (f.OrdSubCats) ClearSelectedList(f.OrdSubCats);
	return false;
}

function DeleteResStatClickHandler(e) {
	if (f.ResStats) ClearSelectedList(f.ResStats);
	return false;
}

function DeleteOrdStatClickHandler(e) {
	if (f.OrdStats) ClearSelectedList(f.OrdStats);
	return false;
}

function DeletePrioClickHandler(e) {
	if (f.Prios) ClearSelectedList(f.Prios);
	return false;
}

function DeleteWardClickHandler(e) {
	// remove selected id from id string
	var obj=document.getElementById("WardLocIDs");
	if (obj) DeleteFromIdString(f.Wards,obj);
    
    if (f.Wards) ClearSelectedList(f.Wards);
    
    PopulateWardIDs();
    
	var obj=document.getElementById("WardCodes");
	if (obj) {
		if (obj.value=="") {
			DisableField("Bed");
			DisableLookup("ld1896iBed");
			var objlist = document.getElementById("Beds");
			if (objlist) ClearAllList(objlist);
			DisableField("Room");
			DisableLookup("ld1896iRoom");
			var objlist = document.getElementById("Rooms");
			if (objlist) ClearAllList(objlist);
		}    
        /*
		var Arroldwards = obj.value.split("|");
		var newwards="";
		for (var i=0; i<f.Wards.options.length; i++) {
			//alert(i + '\n'+f.Wards.options[i].selected+'\n'+f.Wards.options[i].text);
			if (!f.Wards.options[i].selected) {
				if (newwards!="") newwards=newwards+"|";
				newwards=newwards+Arroldwards[i];
			}
		}
		obj.value = newwards;
        */
	}

	return false;
}

function DeleteBedClickHandler(e) {
	ClearSelectedList(f.Beds);
	return false;
}

function DeleteRoomClickHandler(e) {
	ClearSelectedList(f.Rooms);
	return false;
}

document.body.onload=DocumentLoadHandler;

//--------------------------------------------------------------
/* ab 52474 - why use custom functions that don't work properly?
changed to use functions in websys.edit.tools.js

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld && (fld.tagName=="INPUT")) {
		fld.disabled = false;
		fld.className = "";
		if (fld.type=="checkbox") {
			fld.onclick=DisableClick;
			fld.checked = false;
		}
		if (fld.type=="text") {
			fld.onkeydown="";
		}		
	}

}
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (fld.type=="checkbox") {
			fld.onclick=DisableClick;
			fld.checked = false;
		}
		if (fld.type=="text") {
			fld.onkeydown=DisableKeyDown;
		}

	}
}

function DisableKeyDown() {
	return false;
}

function DisableClick() {
	return false;
}

function DisableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=true;
}

function EnableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=false;
}
*/

// manages the | delimited string of ids when a listbox item is deleted
function DeleteFromIdString(list,obj) {
	var str="";
	var ary2=new Array();
	if ((list)&&(obj)) {
		var ary=obj.value.split("|");
		for (var i=0;i<list.length;i++) {
			if (list.options[i].selected) ary[i]="";
		}
		for (var i=0;i<ary.length;i++) {
			if (ary[i]!="") ary2.push(ary[i]);
		}
		obj.value=ary2.join("|");
	}
	GetLocAndWardIDs();
}


function GetLocAndWardIDs() {
	var objLocAndWardIDs=document.getElementById("LocAndWardIDs");
	if (objLocAndWardIDs) {
		var LocIDs="";
		var objLocIDs=document.getElementById("LocIDs");
		if (objLocIDs) LocIDs=objLocIDs.value;
		var WardLocIDs="";
		var objWardLocIDs=document.getElementById("WardLocIDs");
		if (objWardLocIDs) WardLocIDs=objWardLocIDs.value;
		if ((LocIDs!="")&&(WardLocIDs!="")) objLocAndWardIDs.value=LocIDs+"|"+WardLocIDs;
		else objLocAndWardIDs.value=LocIDs+WardLocIDs;
	}
}


function GetDefaults() {
	var objPrefParams=document.getElementById("PrefParams");
	var objWorkListParams=document.getElementById("WorkListParams");
	if ((objPrefParams)&&(objWorkListParams)) {
		if (objPrefParams.value!="") {

			//preferences exist...

			var aryParams = objPrefParams.value.split("^");
            
			if (aryParams.length > 21) {
				var obj=document.getElementById("WIPDateFromToday");
				if (obj) {
					if (aryParams[0]=="on") {
						obj.checked = true;
					} else {
						obj.checked = false;
					}
				}
				var obj=document.getElementById("WIPDtFromOffset");
				if (obj) {
					obj.value = aryParams[1];
				}
				var obj=document.getElementById("WIPDateToToday");
				if (obj) {
					if (aryParams[2]=="on") {
						obj.checked = true;
					} else {
						obj.checked = false;
					}
				}
				var obj=document.getElementById("WIPDTToOffset");
				if (obj) {
					obj.value = aryParams[3];
				}
				var obj = document.getElementById("WIPEpisodeTypeList");
				if (obj) {
					obj.value = aryParams[4];
				}
				var obj = document.getElementById("WIPHospitalList");
				if (obj) {
					obj.value = aryParams[5];
				}
				var obj = document.getElementById("HospIDs");
				if (obj) {
					var arrhospstr = aryParams[5].split(String.fromCharCode(1));
					var ids = "";
					for (var tmphosp = 0; tmphosp < arrhospstr.length; tmphosp++) {
						var arypiece = arrhospstr[tmphosp].split(String.fromCharCode(2));
						if (arypiece.length > 2) {
							if (ids !="" ) { ids+= "|";}
                            ids+= arypiece[2];
						}
					}
					obj.value = ids;
				}
				var obj = document.getElementById("WIPCPList");
				if (obj) {
					obj.value = aryParams[6];
				}
				var obj = document.getElementById("WIPSpecialtyList");
				if (obj) {
					obj.value = aryParams[7];
				}
				var obj = document.getElementById("WIPLocList");
				if (obj) {
					obj.value = aryParams[8];
					// ab 29.10.04 46930 - copy all location ids into "LocIDs" field
                    var locid1=aryParams[8].split(String.fromCharCode(1));
                    var objLocIds=document.getElementById("LocIDs");
					for (var i=0;i<locid1.length;i++) {
						if (locid1[i]!="") {
                        	var locid2=locid1[i].split(String.fromCharCode(2));
                        	if (objLocIds) {
                                if (objLocIds.value !="" ) { objLocIds.value+= "|";}
                                objLocIds.value=objLocIds.value+locid2[2];
                            }
						}
                    }
                    //if (objLocIds) objLocIds.value=objLocIds.value.substr(1,objLocIds.value.length);
				}
				var obj = document.getElementById("WIPOrderCatList");
				if (obj) {
					obj.value = aryParams[9];
				}
				var obj = document.getElementById("WIPOrderSubCatList");
				if (obj) {
					obj.value = aryParams[10];
				}
				var obj = document.getElementById("WIPResultStatus");
				if (obj) {
					obj.value = aryParams[11];
				}
				var obj = document.getElementById("WIPOrderStatus");
				if (obj) {
					obj.value = aryParams[12];
				}
				var obj = document.getElementById("WIPPrioList");
				if (obj) {
					obj.value = aryParams[13];
				}
				// 14 is for OrderingCP - not a preference
				var obj = document.getElementById("WIPUnitList");
				if (obj) {
					obj.value = aryParams[15];
				}
				var obj = document.getElementById("WIPWardList");
				if (obj) {
					obj.value = aryParams[16];
					//alert(String.fromCharCode(1)+String.fromCharCode(2)+String.fromCharCode(3)+String.fromCharCode(4));
					var locid1=aryParams[16].split(String.fromCharCode(1));
                    var objLocIds=document.getElementById("WardLocIDs");
					for (var i=0;i<locid1.length;i++) {
						if (locid1[i]!="") {
                        	var locid2=locid1[i].split(String.fromCharCode(2));
							if (objLocIds) objLocIds.value=objLocIds.value+"|"+locid2[3];
						}
                    }
                    if (objLocIds) objLocIds.value=objLocIds.value.substr(1,objLocIds.value.length);
				}
				var obj = document.getElementById("WIPBedList");
				if (obj) {
					obj.value = aryParams[17];
				}
				var obj = document.getElementById("WIPRoomList");
				if (obj) {
					obj.value = aryParams[18];
				}
				var obj = document.getElementById("WIPAdminStatsList");
				if (obj) {
					obj.value = aryParams[19];
				}
                // ab 2.06.05 52290
				var obj=document.getElementById("WIPTmFrom");
				if (obj) {
					obj.value = aryParams[20];
				}
                var obj=document.getElementById("WIPTmTo");
				if (obj) {
					obj.value = aryParams[21];
				}
				var obj = document.getElementById("WIPRecLocsList");
				if (obj) {
					obj.value = aryParams[22];
				}                
				var obj = document.getElementById("WIPAdminRoutesList");
				if (obj) {
					obj.value = aryParams[23];
				}

			}

		} else {

			// no prefs - so use WorkList defaults
			var aryParams = objWorkListParams.value.split("^");
			if (aryParams.length > 41) {
				var obj=document.getElementById("WIPDateFromToday");
				if (obj) {
					if (aryParams[36]==1) {
						obj.checked = true;
					} else {
						obj.checked = false;
					}
				}
				var obj=document.getElementById("WIPDtFromOffset");
				if (obj) {
					obj.value = aryParams[37];
				}
				var obj=document.getElementById("WIPDateToToday");
				if (obj) {
					if (aryParams[38]==1) {
						obj.checked = true;
					} else {
						obj.checked = false;
					}
				}
				var obj=document.getElementById("WIPDtToOffset");
				if (obj) {
					obj.value = aryParams[39];
				}
				var obj = document.getElementById("WIPEpisodeTypeList");
				if (obj) {
					obj.value = aryParams[26];
				}
				var obj = document.getElementById("WIPHospitalList");
				if (obj) {
					obj.value = aryParams[22];
				}
				var obj = document.getElementById("HospIDs");
				if (obj) {
					var arrhospstr = aryParams[22].split(String.fromCharCode(1));
					var ids = "";
					for (var tmphosp = 0; tmphosp < arrhospstr.length; tmphosp++) {
						var arypiece = arrhospstr[tmphosp].split(String.fromCharCode(2))
						if (arypiece.length > 2) {
							if (ids !="" ) { ids+= "|";}
							ids+= arypiece[2];
						}
					}
					obj.value = ids;
				}
				var obj = document.getElementById("WIPCPList");
				if (obj) {
					obj.value = aryParams[25];
				}
				var obj = document.getElementById("WIPSpecialtyList");
				if (obj) {
					obj.value = aryParams[24];
				}
				var obj = document.getElementById("WIPLocList");
				if (obj) {
					obj.value = aryParams[29];
                    // ab 29.10.04 46930 - copy all location ids into "LocIDs" field
                    var locid1=aryParams[29].split(String.fromCharCode(1));
                    var objLocIds=document.getElementById("LocIDs");
                    for (var i=0;i<locid1.length;i++) {
						if (locid1[i]!="") {
                        	var locid2=locid1[i].split(String.fromCharCode(2));
                        	if (objLocIds) objLocIds.value=objLocIds.value+"|"+locid2[2];
						}
                    }
                    if (objLocIds) objLocIds.value=objLocIds.value.substr(1,objLocIds.value.length);
				}
				var obj = document.getElementById("WIPOrderCatList");
				if (obj) {
					obj.value = aryParams[27];
				}
				var obj = document.getElementById("WIPOrderSubCatList");
				if (obj) {
					obj.value = aryParams[28];
				}
				var obj = document.getElementById("WIPResultStatus");
				if (obj) {
					obj.value = aryParams[30];
				}
				var obj = document.getElementById("WIPOrderStatus");
				if (obj) {
					obj.value = aryParams[31];
				}
				var obj = document.getElementById("WIPPrioList");
				if (obj) {
					obj.value = "";
				}
				// 14 is for OrderingCP - not a preference
				var obj = document.getElementById("WIPUnitList");
				if (obj) {
					obj.value = aryParams[33];
				}
				var obj = document.getElementById("WIPWardList");
				if (obj) {
					obj.value = aryParams[34];
					var locid1=aryParams[34].split(String.fromCharCode(1));
                    var objLocIds=document.getElementById("WardLocIDs");
                    for (var i=0;i<locid1.length;i++) {
						if (locid1[i]!="") {
                        	var locid2=locid1[i].split(String.fromCharCode(2));
							if (objLocIds) objLocIds.value=objLocIds.value+"|"+locid2[3];
						}
                    }
                    if (objLocIds) objLocIds.value=objLocIds.value.substr(1,objLocIds.value.length);
				}
				var obj = document.getElementById("WIPBedList");
				if (obj) {
					obj.value = "";
				}
				var obj = document.getElementById("WIPRoomList");
				if (obj) {
					obj.value = "";
				}
				var obj = document.getElementById("WIPAdminStatsList");
				if (obj) {
					obj.value = "";
				}
				var obj = document.getElementById("WIPRecLocsList");
				if (obj) {
					obj.value = aryParams[44];
				}                

			}

		}  // if (objPrefParams.value!="" )
	}
	GetLocAndWardIDs();
}

function SetDateVal() {
	if ((DFOObj)&&(DFOObj.value!="")) DFInit=DFInit+DFOObj.value;
	if ((DFCObj)&&(DFCObj.value!="")) DFInit=DFInit+DFCObj.value;
	if ((DTOObj)&&(DTOObj.value!="")) DTInit=DTInit+DTOObj.value;
	if ((DTCObj)&&(DTCObj.value!="")) DTInit=DTInit+DTCObj.value;

	if(DFInit) DFInit=DFInit.replace("undefined","");
	if(DTInit) DTInit=DTInit.replace("undefined","");
	return true;
}

function TestDateVal() {

	var par_win=window.opener;
	if ((DFOObj)&&(DFOObj.value!="")) DFFinal=DFFinal+DFOObj.value;
	if ((DFCObj)&&(DFCObj.value!="")) DFFinal=DFFinal+DFCObj.value;
	if ((DTOObj)&&(DTOObj.value!="")) DTFinal=DTFinal+DTOObj.value;
	if ((DTCObj)&&(DTCObj.value!="")) DTFinal=DTFinal+DTCObj.value;

	if(DFFinal) DFFinal=DFFinal.replace("undefined","");
	if(DTFinal) DTFinal=DTFinal.replace("undefined","");

	if(DFFinal!=DFInit) {
		var DocWBDF=par_win.document.getElementById("dtFrom");
		if(DocWBDF) DocWBDF.value=""
	}
	if(DTFinal!=DTInit) {
		var DocWBDT=par_win.document.getElementById("dtTo");
		if(DocWBDT) DocWBDT.value=""
	}
	return true;

}

// ab 1.04.05 - flag listboxes as per TN email
function FlagListboxes() {
    if (document.getElementById("AdminStats")) {document.getElementById("AdminStats").tkItemPopulate=1;}
    if (document.getElementById("AdminRoutes")) {document.getElementById("AdminRoutes").tkItemPopulate=1;}
    if (document.getElementById("RecLocs")) {document.getElementById("RecLocs").tkItemPopulate=1;}
    if (document.getElementById("Beds")) {document.getElementById("Beds").tkItemPopulate=1;}
    if (document.getElementById("CPs")) {document.getElementById("CPs").tkItemPopulate=1;}
    if (document.getElementById("Hosps")) {document.getElementById("Hosps").tkItemPopulate=1;}
    if (document.getElementById("Locs")) {document.getElementById("Locs").tkItemPopulate=1;}
    if (document.getElementById("OrdCats")) {document.getElementById("OrdCats").tkItemPopulate=1;}
    if (document.getElementById("OrdStats")) {document.getElementById("OrdStats").tkItemPopulate=1;}
    if (document.getElementById("OrdSubCats")) {document.getElementById("OrdSubCats").tkItemPopulate=1;}
    if (document.getElementById("Prios")) {document.getElementById("Prios").tkItemPopulate=1;}
    if (document.getElementById("ResStats")) {document.getElementById("ResStats").tkItemPopulate=1;}
    if (document.getElementById("Rooms")) {document.getElementById("Rooms").tkItemPopulate=1;}
    if (document.getElementById("Specs")) {document.getElementById("Specs").tkItemPopulate=1;}
    if (document.getElementById("Wards")) {document.getElementById("Wards").tkItemPopulate=1;}
}

// ab 31.01.06 - 57935 - called from menu

function GetDesc(type) {
	var desc = t["SaveU"]+" (" + session['LOGON.USERCODE'] + ")";
	if (type=="L") {
		var loc=document.getElementById("LogonLoc");
		if (loc) loc=loc.value;
		desc = t["SaveL"]+" (" + loc + ")";
	}
	if (type=="G") desc = t["SaveG"]+" (" + session['LOGON.GROUPDESC'] + ")";
	if (type=="T") desc = t["SaveT"]+" (" + session['LOGON.SITECODE'] + ")";
	return desc;
}

function SetOrgFavSaveAs(type,load) {
	//document.fPACWard_FindWardBedStat_Preferences.type.value=type;
	if (load) {
		var obj=document.getElementById('ActivePref');
		if ((obj)&&(type!="")) obj.innerText=GetDesc(type);
	}

	if (!type) type="U";
	var obj=document.getElementById('SaveAs');
	if (obj) obj.innerText=GetDesc(type);
	var obj=document.getElementById('SaveAsHidden');
	if (obj) obj.value=type;
	
}