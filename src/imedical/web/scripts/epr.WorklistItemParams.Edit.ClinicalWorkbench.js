// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


f=document.fepr_WorklistItemParams_Edit_ClinicalWorkbench;

function DocumentLoadHandler()
{
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
	var obj = document.getElementById("DeleteTab");
	if (obj) obj.onclick = DeleteNurseTabClickHandler;
	var obj = document.getElementById("deleteRecLocs");
	if (obj) obj.onclick = DeleteRecLocsClickHandler;
	var obj = document.getElementById("AddTab");
	if (obj) obj.onclick = AddNurseTabToList;
	var obj = document.getElementById("AddTab2");
	if (obj) obj.onclick = AddNurseTabToList;


	var obj=document.getElementById("OrdersList");
	if (obj) obj.onclick=disableFields;
	
	var obj=document.getElementById("ResultList");
	if (obj) obj.onclick=disableFields;
	
	var obj=document.getElementById("NursesList");
	if (obj) obj.onclick=disableFields;

	var obj=document.getElementById("WIPDateToToday");
	if (obj) obj.onclick=disableFields;
	
	var obj=document.getElementById("WIPDateFromToday");
	if (obj) obj.onclick=disableFields;

	var obj=document.getElementById("WIPLogonCP");
	if (obj) {
		obj.onclick=disableFields;
		var objList = document.getElementById("WIPCPList");
		var objlistbox = document.getElementById("CPs");
		if (objList && objlistbox) {
			AddAllItemsToList(objlistbox, objList.value);
		}
	}
  

	var obj=document.getElementById("WIPLogonHosp");
	if (obj) {
		obj.onclick=LogonHospClickHandler;
		LogonHospClickHandler();
		var objList = document.getElementById("WIPHospitalList");
		var objlistbox = document.getElementById("Hosps");
		if (objList && objlistbox) {
			AddAllItemsToList(objlistbox, objList.value);
		}
	}

	var obj=document.getElementById("WIPLogonSpecialty");
	if (obj) {
		obj.onclick=disableFields;
		var objList = document.getElementById("WIPSpecialtyList");
		var objlistbox = document.getElementById("Specs");
		if (objList && objlistbox) {
			AddAllItemsToList(objlistbox, objList.value);
		}
	}

	var obj=document.getElementById("WIPLogonLoc");
	if (obj) {
		  obj.onclick=LogonLocClickHandler;
		  var objList = document.getElementById("WIPLocList");
		  var objlistbox = document.getElementById("Locs");
		  if (objList && objlistbox) {
			  AddAllItemsToList(objlistbox, objList.value);
		  }
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
	  var objList = document.getElementById("WIPWardList");
	  var objlistbox = document.getElementById("Wards");
	  if (objList && objlistbox) {
		  AddAllItemsToList(objlistbox, objList.value);
	  }

	var objList = document.getElementById("WIPNurseTabList");
	var objlistbox = document.getElementById("NurseTabs");
	if (objList && objlistbox) {
		var tmp = objList.value.split(String.fromCharCode(1));
		for (var pce=0; pce < tmp.length; pce ++) {
			AddItemToList(objlistbox, tmp[pce].split("^"), tmp[pce].split("^"));
		}
	}
      
	var objList = document.getElementById("WIPReceivingLoc");
	var objlistbox = document.getElementById("RecLocs");
	if (objList && objlistbox) {
		AddAllItemsToList(objlistbox, objList.value);
	}
      
	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	
	var objOrdersList=document.getElementById("OrdersList");
	var objResultList=document.getElementById("ResultList");
	var objNursesList=document.getElementById("NursesList");
	var listtype = document.getElementById("WIPClinicListType");
	if (listtype) {
	if (listtype.value == "O") {
		if (objOrdersList) objOrdersList.click();
		} else if (listtype.value == "R") {
			if (objResultList) objResultList.click();
		} else if (listtype.value == "N") {
			if (objNursesList) objNursesList.click();
		}
	}

	var objOutPat=document.getElementById("EpisodeOutPat");
	var objInPat=document.getElementById("EpisodeInPat");
	var objEmerPat = document.getElementById("EpisodeEmerPat");
	var objEpisType = document.getElementById("WIPEpisodeTypeList");
	if (objEpisType) {
		if (objOutPat && (objEpisType.value.indexOf("O") != -1)) objOutPat.checked = true;
		if (objInPat && (objEpisType.value.indexOf("I") != -1)) objInPat.checked = true;
		if (objEmerPat && (objEpisType.value.indexOf("E") != -1)) objEmerPat.checked = true;
	}
    
	FlagListboxes();
    
	// ab 7.02.06 57935
	var objlistbox = document.getElementById("NurseTabs");
	if (objlistbox) {
		objlistbox.multiple=false;
		objlistbox.onclick=NurseTabsClickHandler;
	}
	
	// ab 15.06.06 59632
	var obj=document.getElementById("TabUp");
	if (obj) obj.onclick=NurseTabUp;
	var obj=document.getElementById("TabDown");
	if (obj) obj.onclick=NurseTabDown;
    
	// ab 18.10.06 61313
	var obj=document.getElementById("TabName");
	if (obj) obj.maxLength=30;
    
	return;
}

function NurseTabUp() {
	var list=document.getElementById("NurseTabs");
	if (list) UpClick(list);
	return false;
}

function NurseTabDown() {
	var list=document.getElementById("NurseTabs");
	if (list) DownClick(list);
	return false;
}

function AddAllItemsToList(obj, list) {
	var tmp = list.split(String.fromCharCode(1));
	for (var pce=0; pce < tmp.length; pce ++) {
		var strings = tmp[pce].split(String.fromCharCode(2));
		//alert(strings[1] + '\n'+ strings[0]);
		if (strings.length > 1) AddItemToList(obj, strings[1].split(","), strings[0].split(","));
	}
}

function UpdateHandler()
{
	var objOrdersList=document.getElementById("OrdersList");
	var objResultList=document.getElementById("ResultList");
	var objNursesList=document.getElementById("NursesList");
	var listtype = document.getElementById("WIPClinicListType");
	if ( listtype ) {
		if (objOrdersList && (objOrdersList.checked)) {
			listtype.value = "O";
		} else if (objResultList && (objResultList.checked)) {
			listtype.value = "R";
		} else if (objNursesList && (objNursesList.checked)) {
			listtype.value = "N";
		}
	}

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
	}

	var objlist = f.Hosps;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPHospitalList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.Specs;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPSpecialtyList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
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
	}

	var objlist = f.OrdCats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPOrderCatList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.OrdSubCats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPOrderSubCatList");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.ResStats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPResultStatus");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.OrdStats;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPOrderStatus");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}

	var objlist = f.NurseTabs;
	if (objlist) {
		var WIPVal = "";
		for (var i=0; i<objlist.length; i++) {
			if (WIPVal!="") WIPVal = WIPVal + String.fromCharCode(1);
			WIPVal = WIPVal + objlist.options[i].value;
		}
		var objWIP=document.getElementById("WIPNurseTabList");
		if (objWIP) objWIP.value = WIPVal;
	}
    
	var objlist = f.RecLocs;
	if (objlist) {
		var ary=returnValuesWithDescriptions(objlist);
		var objWIP=document.getElementById("WIPReceivingLoc");
		if (objWIP) objWIP.value = ary.join(String.fromCharCode(1));
	}    

	ResetDefaultTabs();
	if(checkMandatory()) return update1_click();
}

function returnValuesWithDescriptions(obj, delim) {
	var ary=new Array();
	if (!delim) { delim = String.fromCharCode(2)};
	for (var i=0; i<obj.length; i++) ary[i]=obj.options[i].value + delim + obj.options[i].text;
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

function disableFields(e) {
	var objOrdersList=document.getElementById("OrdersList");
	var objResultList=document.getElementById("ResultList");
	var objNurseList=document.getElementById("NursesList");
	var objWIPDateToToday=document.getElementById("WIPDateToToday");
	var objWIPDateFromToday=document.getElementById("WIPDateFromToday");
	var objWIPDtToOffset=document.getElementById("WIPDtToOffset");
	var objWIPDtFromOffset=document.getElementById("WIPDtFromOffset");
	
	var objWIPLogonCP=document.getElementById("WIPLogonCP");
	var objCPs=document.getElementById("CPs");
	var objCP=document.getElementById("CP");
	
	var objWIPLogonSpec=document.getElementById("WIPLogonSpecialty");
	var objSpecialty=document.getElementById("Specialty");
	var objSpecs=document.getElementById("Specs");
	
	var objClinListType=document.getElementById("WIPClinicListType");
	var Nurse="";
	
	if (objNurseList) {
		if (objNurseList.checked==true) {
			Nurse="Y";
		} else {
			Nurse="N";
		}
	} else {
		if ((objClinListType)&&(objClinListType.value=="N")) {
			Nurse="Y"
		} else {
			Nurse="N";
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
	
	// ab 14.03.06 58521 - if nurses worklist, dont enable these checkboxes
	if (Nurse=="N") {
		if (objWIPLogonCP) {
			if (objWIPLogonCP.checked) {
			    DisableField("CP");
			    DisableLookup("ld1892iCP");
			    var obj = document.getElementById("CPs");
			    if (obj) ClearAllList(obj);
			} else  {
			    EnableField("CP");
			    EnableLookup("ld1892iCP");
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
	}
	//alert(window.event.srcElement);
	
	if (window.event.srcElement) {
		var eSrc = window.event.srcElement.id;
		if (eSrc == "OrdersList") {
			if ( (objOrdersList)&&(objOrdersList.checked) ) {
				EnableField("OrderStatus");
				EnableLookup("ld1892iOrderStatus");
		    
				EnableField("OrderSubCat");
				EnableLookup("ld1892iOrderSubCat");
		    
				EnableField("OrderCat");
				EnableLookup("ld1892iOrderCat");
		    
				EnableField("EpisodeOutPat");
				EnableField("EpisodeInPat");
				EnableField("EpisodeEmerPat");
		    
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
		    
				EnableField("RecLoc");
				EnableLookup("ld1892iRecLoc");
    
				DisableField("ResultStatus");
				DisableLookup("ld1892iResultStatus");
				var obj = document.getElementById("ResStats");
				if (obj) ClearAllList(obj);
		    
				if (objResultList) objResultList.checked = false;
				if (objNurseList) objNurseList.checked = false;
		    
				DisableField("TabName");
				DisableField("DeleteTab");
				DisableField("AddTab");
				DisableField("TabType");
				DisableLookup("ld1892iTabType");
				var obj = document.getElementById("NurseTabs");
				if (obj) ClearAllList(obj);
				var obj=document.getElementById("Preferences");
				if (obj) {
					obj.disabled=true;
					obj.onclick=LinkDisable;
				}
			}
    
		} else if (eSrc == "ResultList") {
			if ( (objResultList)&&(objResultList.checked) ) {
				EnableField("ResultStatus");
				EnableLookup("ld1892iResultStatus");
		    
				EnableField("EpisodeOutPat");
				EnableField("EpisodeInPat");
				EnableField("EpisodeEmerPat");
		    
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
    
				DisableField("OrderStatus");
				DisableLookup("ld1892iOrderStatus");
				var obj = document.getElementById("OrdStats");
				if (obj) ClearAllList(obj);
		    
				EnableField("OrderSubCat");
				EnableLookup("ld1892iOrderSubCat");
		    
				EnableField("OrderCat");
				EnableLookup("ld1892iOrderCat");
				
				EnableField("RecLoc");
				EnableLookup("ld1892iRecLoc");
		    
				if (objOrdersList) objOrdersList.checked = false;
				if (objNurseList) objNurseList.checked = false;
		    
				DisableField("TabName");
				DisableField("DeleteTab");
				DisableField("AddTab");
				DisableField("TabType");
				DisableLookup("ld1892iTabType");
				var obj = document.getElementById("NurseTabs");
				if (obj) ClearAllList(obj);
		    
				var obj=document.getElementById("Preferences");
				if (obj) {
					obj.disabled=true;
					obj.onclick=LinkDisable;
				}
			}
		} else if (eSrc == "NursesList") {
			if ( (objNurseList)&&(objNurseList.checked) ) {
	
				if (objOrdersList) objOrdersList.checked = false;
				if (objResultList) objResultList.checked = false;
				DisableField("OrderStatus");
				DisableLookup("ld1892iOrderStatus");
				var obj = document.getElementById("OrdStats");
				if (obj) ClearAllList(obj);
		    
				DisableField("ResultStatus");
				DisableLookup("ld1892iResultStatus");
				var obj = document.getElementById("ResStats");
				if (obj) ClearAllList(obj);
		    
				DisableField("OrderSubCat");
				DisableLookup("ld1892iOrderSubCat");
				var obj = document.getElementById("OrdSubCats");
				if (obj) ClearAllList(obj);                
		    
				DisableField("OrderCat");
				DisableLookup("ld1892iOrderCat");
				var obj = document.getElementById("OrdCats");
				if (obj) ClearAllList(obj);                             
		    
				DisableField("EpisodeOutPat");
				DisableField("EpisodeInPat");
				DisableField("EpisodeEmerPat");
    
				DisableField("WIPLogonCP");
				DisableField("CP");
				DisableLookup("ld1892iCP");
				var obj = document.getElementById("CPs");
				if (obj) ClearAllList(obj);
		    
				DisableField("WIPLogonHosp");
				DisableField("Hospital");
				DisableLookup("ld1892iHospital");
				var obj = document.getElementById("Hosps");
				if (obj) ClearAllList(obj);
		    
				DisableField("RecLoc");
				DisableLookup("ld1892iRecLoc");
				var obj = document.getElementById("RecLocs");
				if (obj) ClearAllList(obj);
		    
				//DisableField("WIPLogonLoc");
				DisableField("Location");
				DisableLookup("ld1892iLocation");
				var obj = document.getElementById("Locs");
				if (obj) ClearAllList(obj);
		    
				DisableField("WIPLogonSpecialty");
				DisableField("Specialty");
				DisableLookup("ld1892iSpecialty");
				var obj = document.getElementById("Specs");
				if (obj) ClearAllList(obj);
				//DisableField("WIPDateFromToday");
				//DisableField("WIPDateToToday");
				//DisableField("WIPDtFromOffset");
				//DisableField("WIPDtToOffset");
		    
				EnableField("TabName");
				EnableField("DeleteTab");
				EnableField("AddTab");
				EnableField("TabType");
				EnableLookup("ld1892iTabType");
    
				var obj=document.getElementById("Preferences");
				if (obj) {
					obj.disabled=false;
					obj.onclick=OpenPreferences;
				}
				
				ResetDefaultTabs();
			}
		}
	} else {
		var obj=document.getElementById("Preferences");
		if (obj) obj.onclick=OpenPreferences;
	}

	return;
}

function LogonHospClickHandler() {
	var objWIPLogonHosp=document.getElementById("WIPLogonHosp");
	if (objWIPLogonHosp) {
		if (objWIPLogonHosp.checked) {
			DisableField("Hospital");
			DisableLookup("ld1892iHospital");
			var obj = document.getElementById("Hosps");
			if (obj) ClearAllList(obj);
			var objLogonHosp=document.getElementById("LogonHospital");
			var objHospIDs=document.getElementById("HospIDs");
			if ((objHospIDs)&&(objLogonHosp)) objHospIDs.value=objLogonHosp.value;
		} else {
			EnableField("Hospital");
			EnableLookup("ld1892iHospital");
			var objHospIDs=document.getElementById("HospIDs");
			if (objHospIDs) objHospIDs.value="";
		}
	}
	disableFields();
}

function LogonLocClickHandler() {
	var objWIPLogonLoc=document.getElementById("WIPLogonLoc");
	var objLocation=document.getElementById("Location");
	var objLocs=document.getElementById("Locs");
    
	// ab 1.08.05 50993 dont enable/disable these fields for the the very special "nurses list"
	var NursesList=false;
	var obj=document.getElementById("NursesList");
	if ((obj)&&(obj.checked==true)) NursesList=true;
    
	if (NursesList==false) {
		if (objWIPLogonLoc) {
		    if (objWIPLogonLoc.checked) {
			DisableField("Location");
			DisableLookup("ld1892iLocation");
			if (obj) ClearAllList(objLocs);
			var objLogonLoc=session['LOGON.CTLOCID'];
			var objLocIDs=document.getElementById("LocIDs");
			if ((objLocIDs)&&(objLogonLoc)) objLocIDs.value=objLogonLoc.value;
		    } else {
			EnableField("Location");
			EnableLookup("ld1892iLocation");
			var objLocIDs=document.getElementById("LocIDs");
			if (objLocIDs) objLocIDs.value="";
		    }
		}
		disableFields();
	}
}

function AddNurseTabToList(e) {
	var objdesc=document.getElementById("TabName");
	var eSrc=websys_getSrcElement(e);
	var type="";
	if (eSrc) eSrc=eSrc.id;
	if (eSrc=="AddTab") type="EXE";
	if (eSrc=="AddTab2") type="SPEC";
	
	//var objtype=document.getElementById("TabType");
	//var objtypecode=document.getElementById("TabTypeCode");
	if (objdesc) {
		if (objdesc.value=="") {
			alert(t['INVALIDTAB']);
			return false;
		} else {
			TransferToList(f.NurseTabs,objdesc.value + "_" + type +"^"+objdesc.value + "_" + type );
			objdesc.value = "";
			//objtypecode.value = "";
			//objtype.value = "";
		}
	}

	return false;

}

function TransferCodeToList (obj, str) {
	// swap pieces 2 and 3
	var txt = str.split("^");
	if (txt.length>1) {
		var newstring = txt[0] + "^" + txt[2];
		TransferToList(obj, newstring);
	}

}

function LookUpTabType(val) {
	var txt = val.split("^");
	var objtypecode=document.getElementById("TabTypeCode");
	var objtype=document.getElementById("TabType");
	if ((txt.length>1) && (objtypecode) && (objtype)) {
		objtypecode.value = txt[0];
		objtype.value = txt[1];
	}
}

function LookUpCP(val) {
	f.CP.value="";
	TransferToList(f.CPs,val)
}

function LookUpHosp(val) {
	f.Hospital.value="";
	TransferCodeToList(f.Hosps,val)

	var txt = val.split("^");
	var obj=document.getElementById("HospIDs");
	if (obj) {
		if (obj.value!="") obj.value=obj.value+"|";
		obj.value=obj.value+txt[1];
	}
}

function LookUpSpec(val) {
	f.Specialty.value="";
	TransferCodeToList(f.Specs,val)
}

function LookUpWard(val) {
	var txt = val.split("^");
	var newstring = txt[0] + "^" + txt[1];
	f.Ward.value="";
	TransferToList(f.Wards, newstring);
}

function LookUpLoc(val) {
	var txt = val.split("^");
	var newstring = txt[1] + "^" + txt[0];
	f.Location.value="";
	TransferToList(f.Locs, newstring);
	//TransferCodeToList(f.Locs,val)


	var obj=document.getElementById("LocIDs");
	if (obj) {
		if (obj.value!="") obj.value=obj.value+"|";
		obj.value=obj.value+txt[3];
	}
}

function LookUpOrdCat(val) {
	f.OrderCat.value="";
	TransferCodeToList(f.OrdCats,val)
}

function LookUpOrderSubCat(val) {
	f.OrderSubCat.value="";
	TransferCodeToList(f.OrdSubCats,val)
}

function LookUpResStat(val) {
	f.ResultStatus.value="";
	//TransferCodeToList(f.ResStats,val)
    var txt = val.split("^");
    if (txt[2]!="") TransferToList(f.ResStats, val);
}

function LookUpOrdStat(val) {
	f.OrderStatus.value="";
	TransferCodeToList(f.OrdStats,val)
}

function LookUpRecLoc(val) {
	f.RecLoc.value="";
	TransferToList(f.RecLocs,val)
}

function DeleteCPClickHandler(e) {
	ClearSelectedList(f.CPs);
	return false;
}

function DeleteHospClickHandler(e) {
	var obj=document.getElementById("HospIDs");
	if (obj) DeleteFromIdString(f.Hosps,obj)

	ClearSelectedList(f.Hosps);
	return false;
}

function DeleteNurseTabClickHandler(e) {
	ClearSelectedList(f.NurseTabs);
	return false;
}

function DeleteRecLocsClickHandler(e) {
	ClearSelectedList(f.RecLocs);
	return false;
}

function DeleteSpecClickHandler(e) {
	ClearSelectedList(f.Specs);
	return false;
}

function DeleteWardClickHandler(e) {
	ClearSelectedList(f.Wards);
	return false;
}

function DeleteLocClickHandler(e) {
	var obj=document.getElementById("LocIDs");
	if (obj) DeleteFromIdString(f.Locs,obj)

	ClearSelectedList(f.Locs);
	return false;
}

function DeleteOrdCatClickHandler(e) {
	ClearSelectedList(f.OrdCats);
	return false;
}

function DeleteOrdSubCatClickHandler(e) {
	ClearSelectedList(f.OrdSubCats);
	return false;
}

function DeleteResStatClickHandler(e) {
	ClearSelectedList(f.ResStats);
	return false;
}

function DeleteOrdStatClickHandler(e) {
	ClearSelectedList(f.OrdStats);
	return false;
}

// ab 7.02.06 57935
function OpenPreferences() {
	var obj=document.getElementById("Preferences");
	var objTabs=document.getElementById("NurseTabs");
	var OpenWindow=1;
	
	// if tabs defined, need to select before opening prefs screen
	if ((objTabs)&&(objTabs.length)&&(objTabs.selectedIndex==-1)) {
		alert(t["SelectTab"]);
		OpenWindow=0;
	}
	
	if (OpenWindow) {
		var objWorkName=document.getElementById("WorkName");
		if (objWorkName) var WorkName=objWorkName.value;
		var objWorkID=document.getElementById("WorkID");
		if (objWorkID) var WorkID=objWorkID.value;
		var objPrefContext=document.getElementById("TabContext");
		if (objPrefContext) var PrefContext=objPrefContext.value;
		var objList=document.getElementById("WIPClinicListType");
		if (objList) ListType=objList.value;
		var objFrame=document.getElementById("Frame");
		if (objFrame) var Frame=objFrame.value;

		var url = "websys.default.csp?WEBSYS.TCOMPONENT=EPVisitNumber.ClinicWorkList.Preferences&WorkName="+WorkName+"&WorkContext="+PrefContext+"&WorkComponent=1895&CONTEXT="+session['CONTEXT']+"&WorkID="+WorkID+"&WIPClinicListType="+ListType+"&frame="+Frame;
		//alert(url);
		websys_lu(url);
	}
	
	return false;

}

function NurseTabsClickHandler() {
	var objTabs=document.getElementById("NurseTabs");
	var objPrefContext=document.getElementById("PrefContext");
	var objTabContext=document.getElementById("TabContext");
	var TabVal="";
	if ((objTabs)&&(objPrefContext)) {
		//alert(objTabs.options[objTabs.selectedIndex].value+"^"+objTabs.options[objTabs.selectedIndex].text);
		TabVal=objTabs.options[objTabs.selectedIndex].value.split("_")[0];
		
		objTabContext.value=objPrefContext.value+"_"+TabVal;
	}
}

function ResetDefaultTabs() {
		var objTabs=document.getElementById("NurseTabs");
		if ((objTabs)&&(objTabs.length==0)) {
			AddItemSingle(objTabs,t["MedTab"]+"_EXE",t["MedTab"]+"_EXE");
			AddItemSingle(objTabs,t["ObsTab"]+"_EXE",t["ObsTab"]+"_EXE");
			AddItemSingle(objTabs,t["SpecTab"]+"_SPEC",t["SpecTab"]+"_SPEC");
		}
}

document.body.onload=DocumentLoadHandler;

//--------------------------------------------------------------
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
}

// ab 24.05.05 - flag listboxes as per TN email
function FlagListboxes() {
    if (document.getElementById("OrdStats")) {document.getElementById("OrdStats").tkItemPopulate=1;}
    if (document.getElementById("CPs")) {document.getElementById("CPs").tkItemPopulate=1;}
    if (document.getElementById("Hosps")) {document.getElementById("Hosps").tkItemPopulate=1;}
    if (document.getElementById("ResStats")) {document.getElementById("ResStats").tkItemPopulate=1;}
    if (document.getElementById("Specs")) {document.getElementById("Specs").tkItemPopulate=1;}
    if (document.getElementById("OrdCats")) {document.getElementById("OrdCats").tkItemPopulate=1;}
    if (document.getElementById("OrdSubCats")) {document.getElementById("OrdSubCats").tkItemPopulate=1;}
    if (document.getElementById("Locs")) {document.getElementById("Locs").tkItemPopulate=1;}
    if (document.getElementById("Wards")) {document.getElementById("Wards").tkItemPopulate=1;}
}

/* ab 52474 - why use custom functions that don't work properly?
changed to use functions in websys.edit.tools.js
*/