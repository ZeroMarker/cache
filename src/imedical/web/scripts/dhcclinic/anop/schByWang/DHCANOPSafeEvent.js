function InitViewScreenEvent(obj)
{
	var SurgueIdStr="",SurgueDescStr="",lastSurgue="",AndocIdStr="",AndocDescStr="",lastAndoc="",OpnurseIdStr="",OpnurseDescStr="",lastOpnurse=""
	var _UDHCANOPArrange=ExtTool.StaticServerObject('web.UDHCANOPArrange');
	var _DHCLCNUREXCUTE=ExtTool.StaticServerObject('web.DHCLCNUREXCUTE');
	
	obj.LoadEvent = function(args)
	{
		var url=location.search; 
	    //var Request = new Object();
	    if(url.indexOf("?")!=-1) {         
		    var str = url.substr(1)    //去掉去掉去掉去掉?号号号号         
		    strs = str.split("&");        
		    for(var i=0;i<strs.length;i++)         
		    {               
		    obj[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);         
		    } 
	    }
	   
	    Ext.getDom("opaId").value=obj["opaId"];
	    Ext.getDom("patName").value=obj["patname"];
	    Ext.getDom("patSex").value=obj["sex"];
	    Ext.getDom("patAge").value=obj["age"];
	    Ext.getDom("txtMedCareNo").value=obj["medCareNo"];
	    //Ext.getDom("anMethod").value=obj["anmethod"];
	    Ext.getDom("opName").value=obj["opname"];
	    //Ext.getDom("opDoctor").value=obj["opdoc"];
	    Ext.getDom("opTime").value=obj["opdatestr"];
	    Ext.getDom("comAppLoc").value=obj["loc"];
	    
	    var appType=obj["appType"];
	    switch(appType)
	    {
		    case "ward":
		         Ext.getDom("opDocName").value=session['LOGON.USERNAME'];
		         break;
		    case "anaes":
		         Ext.getDom("anDocName").value=session['LOGON.USERNAME'];
		         break;
		    case "op":
		         Ext.getDom("opNurseName").value=session['LOGON.USERNAME'];
		         break;
		    default:
				break;
		    
	    }
	    
	    var opaId=Ext.getDom("opaId").value;
	    var CheckInfoStr=_UDHCANOPArrange.GetCheckInfo(opaId);
	    //alert(CheckInfoStr);
	    var CheckInfo=CheckInfoStr.split("#");
	    var checkInfoAnStr=CheckInfo[0].split("^");
	    var checkInfoOpStr=CheckInfo[1].split("^");
	    var checkInfoLeaveStr=CheckInfo[2].split("^");
	    if(checkInfoAnStr!="")
	    {
		    //anPatInfoDesc^anSurgueDesc+"/"+SurgueIdStr^anAnDocDesc^anOpNurseDesc^anopMethodCheck^anopSiteCheck^opKnowCheck^anKnowCheck^anSafeCheck
			//OxygenMonitor^allergyCheck^Airway^veinPassCheck^patSkinCheck^AutologousBlood^preOpBloodCheck^Prosthesis^Implants^Metal^anOther
		    Ext.getDom("anPatInfoDesc").value=checkInfoAnStr[0];
			Ext.getDom("anSurgueDesc").value=checkInfoAnStr[1];
			Ext.getDom("anAnDocDesc").value=checkInfoAnStr[2];
			Ext.getDom("anOpNurseDesc").value=checkInfoAnStr[3];
			Ext.getDom("anopMethodCheck").value=checkInfoAnStr[4];
			Ext.getDom("anopSiteCheck").value=checkInfoAnStr[5];
			Ext.getDom("opKnowCheck").value=checkInfoAnStr[6];
			Ext.getDom("anKnowCheck").value=checkInfoAnStr[7];
			Ext.getDom("anSafeCheck").value=checkInfoAnStr[8];
			Ext.getDom("OxygenMonitor").value=checkInfoAnStr[9];
			Ext.getDom("allergyCheck").value=checkInfoAnStr[10];
			Ext.getDom("Airway").value=checkInfoAnStr[11];
			Ext.getDom("veinPassCheck").value=checkInfoAnStr[12];
			Ext.getDom("patSkinCheck").value=checkInfoAnStr[13];
			Ext.getDom("AutologousBlood").value=checkInfoAnStr[14];
			Ext.getDom("preOpBloodCheck").value=checkInfoAnStr[15];
			Ext.getDom("Prosthesis").value=checkInfoAnStr[16];
			Ext.getDom("Implants").value=checkInfoAnStr[17];
			Ext.getDom("Metal").value=checkInfoAnStr[18];
			Ext.getDom("anOther").value=checkInfoAnStr[19];
		}
	    if(checkInfoOpStr!="")
	    {
		    //opPatInfoDesc^opSurgueDesc^opAnDocDesc^opOpNurseDesc^opMethodCheck^opSiteCheck^opPosition^anopWarn
			//opDocState^anDocState^opNurseState^Antibiotic^imageCheck^opOther

		    Ext.getDom("opPatInfoDesc").value=checkInfoOpStr[0];
			Ext.getDom("opSurgueDesc").value=checkInfoOpStr[1];
			Ext.getDom("opAnDocDesc").value=checkInfoOpStr[2];
			Ext.getDom("opOpNurseDesc").value=checkInfoOpStr[3];
			Ext.getDom("opMethodCheck").value=checkInfoOpStr[4];
			Ext.getDom("opSiteCheck").value=checkInfoOpStr[5];
			Ext.getDom("opPosition").value=checkInfoOpStr[6];
			Ext.getDom("anopWarn").value=checkInfoOpStr[7];
			Ext.getDom("opDocState").value=checkInfoOpStr[8];
			Ext.getDom("anDocState").value=checkInfoOpStr[9];
			Ext.getDom("opNurseState").value=checkInfoOpStr[10];
			Ext.getDom("Antibiotic").value=checkInfoOpStr[11];
			Ext.getDom("imageCheck").value=checkInfoOpStr[12];
			Ext.getDom("opOther").value=checkInfoOpStr[13];
	    }
	    if(checkInfoLeaveStr!="")
	    {
		    //prePatInfoDesc^preSurgueDesc^preAnDocDesc^preOpNurseDesc^factMethodCheck^opGoodsCheck^opSpecimen^tpatSkinCheck
			//Equipment^patGo^tAutologousBlood^tpreOpBloodCheck^everyCanal^anopOther
			Ext.getDom("prePatInfoDesc").value=checkInfoLeaveStr[0];
			Ext.getDom("preSurgueDesc").value=checkInfoLeaveStr[1];
			Ext.getDom("preAnDocDesc").value=checkInfoLeaveStr[2];
			Ext.getDom("preOpNurseDesc").value=checkInfoLeaveStr[3];
			Ext.getDom("factMethodCheck").value=checkInfoLeaveStr[4];
			Ext.getDom("opGoodsCheck").value=checkInfoLeaveStr[5];
			Ext.getDom("opSpecimen").value=checkInfoLeaveStr[6];
			Ext.getDom("tpatSkinCheck").value=checkInfoLeaveStr[7];
			Ext.getDom("Equipment").value=checkInfoLeaveStr[8];
			Ext.getDom("patGo").value=checkInfoLeaveStr[9];
			Ext.getDom("tAutologousBlood").value=checkInfoLeaveStr[10];
			Ext.getDom("tpreOpBloodCheck").value=checkInfoLeaveStr[11];
			Ext.getDom("everyCanal").value=checkInfoLeaveStr[12];
			Ext.getDom("anopOther").value=checkInfoLeaveStr[13];
	    }
	    
	   // alert(0);
	    //Ext.getCmp('opaId').setValue(opaId);
		/*
		var userId=session['LOGON.USERID'];
	    var loc="^".split("^");
	    var ret=_UDHCANOPArrange.GetDocLoc(userId)
	    if (ret!="")
	    {
			loc=ret.split("^");
	    }  
	
	alert(ret)
	obj.comAppLoc.setValue(loc[1]);
	Ext.getDom("comAppLoc").value=loc[0];
	*/
	
	
	
	
	}
	//anPatInfoCheck^anopMethodCheck^anopSiteCheck^opKnowCheck^anKnowCheck^anSafeCheck
	//^patSkinCheck^patSkinReadyCheck^veinPassCheck^allergyCheck^antibiosisCheck^preOpBloodCheck
	obj.btnSave_click = function()
	{
		var checkflag=check();
		if(!checkflag) 
		{
			alert("失败");
			return;
		}
		else
		{
		//SurgueIdStr="",SurgueDescStr="",AndocIdStr="",AndocDescStr="",OpnurseIdStr="",OpnurseDescStr=""
		var checkInfoAnStr="",checkInfoOpStr="",checkInfoLeaveStr=""
		var opaId=Ext.getDom("opaId").value;
		
		//anPatInfoDesc^anSurgueDesc+"/"+SurgueIdStr^anAnDocDesc^anOpNurseDesc^anopMethodCheck^anopSiteCheck^opKnowCheck^anKnowCheck^anSafeCheck
		//OxygenMonitor^allergyCheck^Airway^veinPassCheck^patSkinCheck^AutologousBlood^preOpBloodCheck^Prosthesis^Implants^Metal^anOther
		var anPatInfoDesc=Ext.getDom("anPatInfoDesc").value;
		var anSurgueDesc=Ext.getDom("anSurgueDesc").value;
		var anAnDocDesc=Ext.getDom("anAnDocDesc").value;
		var anOpNurseDesc=Ext.getDom("anOpNurseDesc").value;
		checkInfoAnStr=anPatInfoDesc+"^"+anSurgueDesc+"^"+anAnDocDesc+"^"+anOpNurseDesc;

		var anopMethodCheck=Ext.getDom("anopMethodCheck").value;
		var anopSiteCheck=Ext.getDom("anopSiteCheck").value;
		var opKnowCheck=Ext.getDom("opKnowCheck").value;
		var anKnowCheck=Ext.getDom("anKnowCheck").value;
		var anSafeCheck=Ext.getDom("anSafeCheck").value;
		checkInfoAnStr=checkInfoAnStr+"^"+anopMethodCheck+"^"+anopSiteCheck+"^"+opKnowCheck+"^"+anKnowCheck+"^"+anSafeCheck;

		var OxygenMonitor=Ext.getDom("OxygenMonitor").value;
		var allergyCheck=Ext.getDom("allergyCheck").value;
		var Airway=Ext.getDom("Airway").value;
		var veinPassCheck=Ext.getDom("veinPassCheck").value;
		var patSkinCheck=Ext.getDom("patSkinCheck").value;
		checkInfoAnStr=checkInfoAnStr+"^"+OxygenMonitor+"^"+allergyCheck+"^"+Airway+"^"+veinPassCheck+"^"+patSkinCheck;

		var AutologousBlood=Ext.getDom("AutologousBlood").value;
		var preOpBloodCheck=Ext.getDom("preOpBloodCheck").value;
		var Prosthesis=Ext.getDom("Prosthesis").value;
		var Implants=Ext.getDom("Implants").value;
		var Metal=Ext.getDom("Metal").value;
		var anOther=Ext.getDom("anOther").value;
		checkInfoAnStr=checkInfoAnStr+"^"+AutologousBlood+"^"+preOpBloodCheck+"^"+Prosthesis+"^"+Implants+"^"+Metal+"^"+anOther;
		//var checkInfoStr1=anPatInfoDesc+"^"+anSurgueDesc+"^"+anAnDocDesc+"^"+anOpNurseDesc+"^"+anopMethod+"^"+anopSite+"^"+opKnow+"^"+anKnow+"^"+anSafe+"^"+patSkin+"^"+patSkinReady+"^"+veinPass+"^"+allergy+"^"+antibiosis+"^"+preOpBlood+"^"+anOther;
		
		//opPatInfoDesc^opSurgueDesc^opAnDocDesc^opOpNurseDesc^opMethodCheck^opSiteCheck^opPosition^anopWarn
		//opDocState^anDocState^opNurseState^Antibiotic^imageCheck^opOther
		var opPatInfoDesc=Ext.getDom("opPatInfoDesc").value;
		var opSurgueDesc=Ext.getDom("opSurgueDesc").value;
		var opAnDocDesc=Ext.getDom("opAnDocDesc").value;
		var opOpNurseDesc=Ext.getDom("opOpNurseDesc").value;
		checkInfoOpStr=opPatInfoDesc+"^"+opSurgueDesc+"^"+opAnDocDesc+"^"+opOpNurseDesc;
		var opMethodCheck=Ext.getDom("opMethodCheck").value;
		var opSiteCheck=Ext.getDom("opSiteCheck").value;
		var opPosition=Ext.getDom("opPosition").value;
		var anopWarn=Ext.getDom("anopWarn").value;
		checkInfoOpStr=checkInfoOpStr+"^"+opMethodCheck+"^"+opSiteCheck+"^"+opPosition+"^"+anopWarn;
		var opDocState=Ext.getDom("opDocState").value;
		var anDocState=Ext.getDom("anDocState").value;
		var opNurseState=Ext.getDom("opNurseState").value;
		checkInfoOpStr=checkInfoOpStr+"^"+opDocState+"^"+anDocState+"^"+opNurseState;
		
		var Antibiotic=Ext.getDom("Antibiotic").value;
		var imageCheck=Ext.getDom("imageCheck").value;
		var opOther=Ext.getDom("opOther").value;
		checkInfoOpStr=checkInfoOpStr+"^"+Antibiotic+"^"+imageCheck+"^"+opOther;
		//var checkInfoStr2=opPatInfoDesc+"^"+opSurgueDesc+"^"+opAnDocDesc+"^"+opOpNurseDesc+"^"+opMethod+"^"+opSite+"^"+operTime+"^"+anopWarn+"^"+opDocState+"^"+anDocState+"^"+opNurseState+"^"+image+"^"+opOther;
				
		//prePatInfoDesc^preSurgueDesc^preAnDocDesc^preOpNurseDesc^factMethodCheck^opGoodsCheck^opSpecimen^tpatSkinCheck
		//Equipment^patGo^tAutologousBlood^tpreOpBloodCheck^everyCanal^anopOther
		var prePatInfoDesc=Ext.getDom("prePatInfoDesc").value;
		var preSurgueDesc=Ext.getDom("preSurgueDesc").value;
		var preAnDocDesc=Ext.getDom("preAnDocDesc").value;
		var preOpNurseDesc=Ext.getDom("preOpNurseDesc").value;
		checkInfoLeaveStr=prePatInfoDesc+"^"+preSurgueDesc+"^"+preAnDocDesc+"^"+preOpNurseDesc;

		var factMethodCheck=Ext.getDom("factMethodCheck").value;
		var opGoodsCheck=Ext.getDom("opGoodsCheck").value;
		var opSpecimen=Ext.getDom("opSpecimen").value;
		var tpatSkinCheck=Ext.getDom("tpatSkinCheck").value;
		checkInfoLeaveStr=checkInfoLeaveStr+"^"+factMethodCheck+"^"+opGoodsCheck+"^"+opSpecimen+"^"+tpatSkinCheck;
		
		var Equipment=Ext.getDom("Equipment").value;
		var patGo=Ext.getDom("patGo").value;
		var tAutologousBlood=Ext.getDom("tAutologousBlood").value;
		var tpreOpBloodCheck=Ext.getDom("tpreOpBloodCheck").value;
		checkInfoLeaveStr=checkInfoLeaveStr+"^"+Equipment+"^"+patGo+"^"+tAutologousBlood+"^"+tpreOpBloodCheck;

		var everyCanal=Ext.getDom("everyCanal").value;
		var anopOther=Ext.getDom("anopOther").value;
		checkInfoLeaveStr=checkInfoLeaveStr+"^"+everyCanal+"^"+anopOther;

		var ret=_UDHCANOPArrange.SaveCheckInfo(opaId,checkInfoAnStr,checkInfoOpStr,checkInfoLeaveStr);
		alert("成功")
		}
	}
	
	function check()
	{
		var flag=true;
		var anPatInfoDesc=Ext.getDom("anPatInfoDesc").value;
		var opPatInfoDesc=Ext.getDom("opPatInfoDesc").value;
		//alert(anPatInfoDesc)
		if(anPatInfoDesc=="")
		{
			alert("病人姓名不能为空!");
			flag=false;
		}
		if((opPatInfoDesc!="")&&(opPatInfoDesc!=anPatInfoDesc))
		{
			alert("请检查病人姓名!");
			flag=false;
		}
		return flag;
	}
	
	obj.btnPrint_click = function()
	{
		var xlsExcel,xlsBook,xlsSheet;	
		var path=_DHCLCNUREXCUTE.GetPath();
		var Template=path+"OSD.xlsx";
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(Template) ;
		xlsSheet = xlsBook.ActiveSheet;
		
		var comAppLoc=Ext.getDom("comAppLoc").value;
	    var patName=Ext.getDom("patName").value;
	    var patSex=Ext.getDom("patSex").value;
	    var patAge=Ext.getDom("patAge").value;
	    var txtMedCareNo=Ext.getDom("txtMedCareNo").value;
	    //var anMethod=Ext.getDom("anMethod").value;
	    var opName=Ext.getDom("opName").value;
	    //var opDoctor=Ext.getDom("opDoctor").value;
	    var opTime=Ext.getDom("opTime").value;
	    	    
		xlsSheet.cells(3,2).FormulaR1C1=comAppLoc;
		xlsSheet.cells(3,4).FormulaR1C1=patName;
		xlsSheet.cells(3,6).FormulaR1C1=patSex;	
		xlsSheet.cells(3,8).FormulaR1C1=patAge;	
		xlsSheet.cells(3,10).FormulaR1C1=txtMedCareNo;	
		//xlsSheet.cells(3,12).FormulaR1C1=anMethod;		
		xlsSheet.cells(4,2).FormulaR1C1=opName;
		//xlsSheet.cells(4,6).FormulaR1C1=opDoctor;
		xlsSheet.cells(4,10).FormulaR1C1=opTime;
	
		
		var anPatInfo=Ext.getDom("anPatInfoCheck").value;
		var anopMethod=Ext.getDom("anopMethodCheck").value;
		var anopSite=Ext.getDom("anopSiteCheck").value;
		var opKnow=Ext.getDom("opKnowCheck").value;
		var anKnow=Ext.getDom("anKnowCheck").value;
		var anSafe=Ext.getDom("anSafeCheck").value;
		var patSkin=Ext.getDom("patSkinCheck").value;
		var patSkinReady=Ext.getDom("patSkinReadyCheck").value;
		var veinPass=Ext.getDom("veinPassCheck").value;
		var allergy=Ext.getDom("allergyCheck").value;
		var antibiosis=Ext.getDom("antibiosisCheck").value;
		var preOpBlood=Ext.getDom("preOpBloodCheck").value;
		var anOther=Ext.getDom("anOther").value;
		
		xlsSheet.cells(7,4).FormulaR1C1=anPatInfo;
		xlsSheet.cells(8,4).FormulaR1C1=anopMethod;
		xlsSheet.cells(9,4).FormulaR1C1=anopSite;	
		xlsSheet.cells(10,4).FormulaR1C1=opKnow;	
		xlsSheet.cells(11,4).FormulaR1C1=anKnow;	
		xlsSheet.cells(12,4).FormulaR1C1=anSafe;		
		xlsSheet.cells(13,3).FormulaR1C1=patSkin;
		xlsSheet.cells(14,4).FormulaR1C1=patSkinReady;
		xlsSheet.cells(15,3).FormulaR1C1=veinPass;
		xlsSheet.cells(16,3).FormulaR1C1=allergy;
		xlsSheet.cells(17,3).FormulaR1C1=antibiosis;
		xlsSheet.cells(18,2).FormulaR1C1=preOpBlood;
		xlsSheet.cells(19,2).FormulaR1C1=anOther;
		
		var PatInfo=Ext.getDom("PatInfoCheck").value;
		var opMethod=Ext.getDom("opMethodCheck").value;
		var opSite=Ext.getDom("opSiteCheck").value;
		var operTime=Ext.getDom("operTime").value;
		var anopWarn=Ext.getDom("anopWarn").value;
		var opDocState=Ext.getDom("opDocState").value;
		var anDocState=Ext.getDom("anDocState").value;
		var opNurseState=Ext.getDom("opNurseState").value;
		var image=Ext.getDom("imageCheck").value;
		var opOther=Ext.getDom("opOther").value;
		
		xlsSheet.cells(7,8).FormulaR1C1=PatInfo;
		xlsSheet.cells(8,8).FormulaR1C1=opMethod;
		xlsSheet.cells(9,8).FormulaR1C1=opSite;	
		xlsSheet.cells(10,7).FormulaR1C1=operTime;	
		xlsSheet.cells(11,8).FormulaR1C1=anopWarn;	
		xlsSheet.cells(12,7).FormulaR1C1=opDocState;		
		xlsSheet.cells(13,8).FormulaR1C1=anDocState;
		xlsSheet.cells(14,7).FormulaR1C1=opNurseState;
		xlsSheet.cells(15,8).FormulaR1C1=image;
		xlsSheet.cells(19,6).FormulaR1C1=opOther;
		
		var prePatInfo=Ext.getDom("prePatInfoCheck").value;
		var factMethod=Ext.getDom("factMethodCheck").value;
		var opDrug=Ext.getDom("opDrugCheck").value;
		var opGoods=Ext.getDom("opGoodsCheck").value;
		var tpatSkin=Ext.getDom("tpatSkinCheck").value;
		var everyCanal=Ext.getDom("everyCanal").value;
		var patGo=Ext.getDom("patGo").value;
		var anopOther=Ext.getDom("anopOther").value;
		
		xlsSheet.cells(7,12).FormulaR1C1=prePatInfo;
		xlsSheet.cells(8,12).FormulaR1C1=factMethod;
		xlsSheet.cells(9,12).FormulaR1C1=opDrug;	
		xlsSheet.cells(10,12).FormulaR1C1=opGoods;	
		xlsSheet.cells(11,11).FormulaR1C1=tpatSkin;	
		xlsSheet.cells(12,10).FormulaR1C1=everyCanal;		
		xlsSheet.cells(13,12).FormulaR1C1=patGo;
		xlsSheet.cells(19,10).FormulaR1C1=anopOther;
		
		
		
		
		
		xlsExcel.Visible = true;
		xlsSheet.PrintPreview;
		//xlsSheet.PrintOut(); 
		
		
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
        //xlsSheet.Application.Quit();
        
		//idTmr = window.setInterval("Cleanup();",1);
		alert(2);
	}
	
	obj.PatInfoDesc_keydown=function()
	{
		if(window.event.keyCode==13)
		{
			var ElementId=document.activeElement.id;
			var ElementValue=Ext.getDom(ElementId).value;
			var patStr=_UDHCANOPArrange.GetPatNameByRegNo(ElementValue);
			var patName=patStr.split("^")[0]
			var patId=patStr.split("^")[1]
			
			if(patName==Ext.getDom("patName").value)
			{
				Ext.getDom(ElementId).value=patName;
				alert(patId)
			}
			else
			{
				alert("病人错误")
			}
		}
	}

	obj.SurgueDesc_keydown=function()
	{
		if(window.event.keyCode==13)
		{
			var ElementId=document.activeElement.id;
			var ElementValue=Ext.getDom(ElementId).value;
			var SSUSRInitials=ElementValue;
			if(lastSurgue!=""&&ElementValue.split(lastSurgue).length>1)
			{
				SSUSRInitials=ElementValue.split(lastSurgue+",")[1]
			}
			var retStr=_UDHCANOPArrange.GetSSUserBySSUSRInitials(SSUSRInitials);
			var retName=retStr.split("^")[0];
			var retId=retStr.split("^")[1];
			var reFlag=_UDHCANOPArrange.CheckCTPCP(Ext.getDom("opaId").value,retId);
			if(reFlag==0)
			{
				lastSurgue=retName;
				SurgueDescStr=SurgueDescStr+retName+",";
				Ext.getDom(ElementId).value=SurgueDescStr;
				SurgueIdStr=SurgueIdStr+retId+",";
			}
			else
			{
				alert("手术医生错误");
				Ext.getDom(ElementId).value=SurgueDescStr;
			}
		}
	}

	obj.AnDocDesc_keydown=function()
	{
		if(window.event.keyCode==13)
		{
			var ElementId=document.activeElement.id;
			var ElementValue=Ext.getDom(ElementId).value;
			var SSUSRInitials=ElementValue;
			if(lastAndoc!=""&&ElementValue.split(lastAndoc).length>1)
			{
				SSUSRInitials=ElementValue.split(lastAndoc+",")[1]
			}
			
			var retStr=_UDHCANOPArrange.GetSSUserBySSUSRInitials(SSUSRInitials);
			var retName=retStr.split("^")[0];
			var retId=retStr.split("^")[1];
			var reFlag=_UDHCANOPArrange.CheckCTPCP(Ext.getDom("opaId").value,retId);
			if(reFlag==0)
			{
				lastAndoc=retName;
				AndocDescStr=AndocDescStr+retName+",";
				Ext.getDom(ElementId).value=AndocDescStr;
				AndocIdStr=AndocIdStr+retId+",";
			}
			else
			{
				alert("麻醉医生错误");
				Ext.getDom(ElementId).value=AndocDescStr;
			}
		}
	}
	obj.OpNurseDesc_keydown=function()
	{
		if(window.event.keyCode==13)
		{
			var ElementId=document.activeElement.id;
			var ElementValue=Ext.getDom(ElementId).value;
			var SSUSRInitials=ElementValue;
			if(lastOpnurse!=""&&ElementValue.split(lastOpnurse).length>1)
			{
				SSUSRInitials=ElementValue.split(lastOpnurse+",")[1]
			}
			
			var retStr=_UDHCANOPArrange.GetSSUserBySSUSRInitials(SSUSRInitials);
			var retName=retStr.split("^")[0];
			var retId=retStr.split("^")[1];
			var reFlag=_UDHCANOPArrange.CheckCTPCP(Ext.getDom("opaId").value,retId);
			if(reFlag==0)
			{
				lastOpnurse=retName;
				OpnurseDescStr=OpnurseDescStr+retName+",";
				Ext.getDom(ElementId).value=OpnurseDescStr;
				OpnurseIdStr=OpnurseIdStr+retId+",";
			}
			else
			{
				alert("手术护士错误");
				Ext.getDom(ElementId).value=OpnurseDescStr;
			}
		}
	}
	
	
	
	
	
	
}