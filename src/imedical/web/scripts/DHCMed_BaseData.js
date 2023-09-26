function BASE_GetDep(encmeth){
	var objDic=new ActiveXObject("Scripting.Dictionary");
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth);
		if (ret!=""){			
			var TempList1=ret.split(CHR_1);
            for (i=0;i<TempList1.length-1;i++){
	            //alert(TempList1[i]);	
	            var TempList2=TempList1[i].split(CHR_2);
	            var objDep=new clsDictionary("")
	            objDep.Rowid=TempList2[0];
	            objDep.Code="";
	            objDep.Desc=TempList2[1];
	            objDic.add(objDep.Rowid,objDep)
	            }	         	
			}	
		return objDic;
		}
	else{return ""};	
	}

function BASE_GetLoc(encmeth,DepRowid){
	var objDic=new ActiveXObject("Scripting.Dictionary");
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,DepRowid);
		if (ret!=""){			
			var TempList1=ret.split(CHR_1);
            for (i=0;i<TempList1.length-1;i++){
	            //alert(TempList1[i]);	
	            var TempList2=TempList1[i].split(CHR_2);
	            var objLoc=new clsDictionary("")
	            objLoc.Rowid=TempList2[0];
	            var TempList3=TempList2[1].split("-");
	            objLoc.Code="";
		          objLoc.Desc=TempList2[1];     //update by zf 2009-02-17
	            objDic.add(objLoc.Rowid,objLoc)
	            }	         	
			}		
		}		
	return objDic;
	}

function BASE_GetDictionary(encmeth,Type,Flag){
	var objDic=new ActiveXObject("Scripting.Dictionary");
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,Type,Flag);
		if (ret!=""){
			var TempList1=ret.split(CHR_1);
            for (i=0;i<TempList1.length-1;i++){
	            //alert(TempList1[i]);	
	            var TempList2=TempList1[i].split(CHR_Up);
	            var objLoc=new clsDictionary("")
	            objLoc.Rowid=TempList2[0];
	            objLoc.Code=TempList2[1];
	            objLoc.Desc=TempList2[2];
	            objDic.add(objLoc.Code,objLoc)
	            }	         	
			}		
		}		
	return objDic;
	}
	
function BASE_GetPatientInfo(encmeth,Papmi){
	
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,Papmi);
		if (ret!=""){
			var objPatient=b_BuildPatInfoObj(ret);
			return objPatient;
			}		    
	    }	
	else{return "";}	
	}

function BASE_UserFunction(encmeth,UserGroupId,ModuleName,MenuName){
	var ret=-1
	if (encmeth!=""){
		ret=cspRunServerMethod(encmeth,UserGroupId,ModuleName,MenuName);
		}
	return ret;
	}
	
//update by zf 2008-06-05
function BASE_GetLogUser(encmeth,xUserId,xGroupId,xCtlocId){
	var objLogUser=new clsLogUser("")
	if (encmeth!=""&&xUserId!=""){
		var UserId="";
		if (xGroupId=="undefined"){xGroupId="";}
		if (xCtlocId=="undefined"){xCtlocId="";}
		if ((xGroupId!=="")||(xCtlocId!=="")){
			UserId=xUserId+"^"+xGroupId+"^"+xCtlocId;
		}else{
			UserId=xUserId;
		}
		ret=cspRunServerMethod(encmeth,UserId);
		if (ret!=""){
			var TempFileds=ret.split(CHR_Up)												
			objLogUser.Rowid=TempFileds[0];
			objLogUser.Code=TempFileds[1];
			objLogUser.Name=TempFileds[2];
			var TempPlist=TempFileds[3].split(CHR_Tilted)
			objLogUser.CtLoc.Rowid=TempPlist[0];
			objLogUser.CtLoc.Code=TempPlist[1];
			objLogUser.CtLoc.Desc=TempPlist[2];
			var TempPlist=TempFileds[4].split(CHR_Tilted)
			objLogUser.CDep.Rowid=TempPlist[0];
			objLogUser.CDep.Code=TempPlist[1];
			objLogUser.CDep.Desc=TempPlist[2];
			var TempPlist=TempFileds[5].split(CHR_Tilted)
			objLogUser.SGroup.Rowid=TempPlist[0];
			objLogUser.SGroup.Code=TempPlist[1];
			objLogUser.SGroup.Desc=TempPlist[2];
			}
		}
	return objLogUser;
	}
function BASE_GetWebConfig(encmeth){
	var objWebConfig=new clsWebConfig("")
	if (encmeth!=""){		
		ret=cspRunServerMethod(encmeth);
		if (ret!=""){
			var TempFileds=ret.split(CHR_1)
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
			}
		}
	return objWebConfig;
	}
