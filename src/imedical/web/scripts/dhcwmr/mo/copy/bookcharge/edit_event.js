function InitEditViewportEvents(obj){
	obj.LoadEvents = function(){
		obj.btnBook.on('click',obj.btnBook_click,obj);
		obj.btnCancel.on('click',obj.btnCancel_click,obj);
		obj.btnCharge.on('click',obj.btnCharge_click,obj);
		obj.btnRetFee.on('click',obj.btnRetFee_click,obj);
		obj.InitBtn();
		obj.LoadData();
	}
	
	obj.InitBtn = function(){
		obj.btnBook.setVisible(false);
		obj.btnCancel.setVisible(false);
		obj.btnCharge.setVisible(false);
		obj.btnRetFee.setVisible(false);
		
		var Status = obj.VC_Input.StatusCode
		
		if ((Status=="RE")||(Status=="BO")) {
			obj.btnBook.setVisible(tDHCWMRMenuOper['BO']);
			obj.btnCancel.setVisible(tDHCWMRMenuOper['U']);
		}
		if ((Status=="BO")||(Status=="RF")){
			obj.btnCharge.setVisible(tDHCWMRMenuOper['CH']);
		}
		if (Status=="CH"){
			obj.btnRetFee.setVisible(tDHCWMRMenuOper['CH']);
		}
	}
	
	obj.LoadData = function (){
		var CopyRecordID = obj.VC_Input.RecordID;
		if (CopyRecordID=="") return "";
		Common_SetValue("ClientName",obj.VC_Input.ClientName);
		Common_SetValue("txtPersonalID",obj.VC_Input.PersonalID);
		Common_SetValue("cboClientRelation",obj.VC_Input.RelationID,obj.VC_Input.RelationDesc);
		Common_SetValue("txtTelephone",obj.VC_Input.Telephone);
		Common_SetValue("cboCardType",obj.VC_Input.CardTypeID,obj.VC_Input.CardTypeDesc);
		Common_SetValue("txtAddress",obj.VC_Input.Address);
		Common_SetValue('cbgPurpose',obj.VC_Input.PurposeIDs);
		Common_SetValue('cbgContent',obj.VC_Input.ContentIDs);
		Common_SetValue("txtNote",obj.VC_Input.Resume);
		Common_SetValue("txtPaperNumber",obj.VC_Input.PaperNumber);
		
		//取病案收费项目单价
		if (obj.VC_Input.CopyMoney != 0) {
			Common_SetValue('txtCopyPrice',"复印费用：" + obj.VC_Input.CopyMoney + '元');
		} else {
			var MrTypeID = obj.VC_Input.MrTypeID;
			var unitPrice = ExtTool.RunServerMethod("DHCWMR.MF.FeeItem","GetTariPrice","FY",MrTypeID,CTHospID);
			var PaperNumber = obj.VC_Input.PaperNumber;
			if (PaperNumber != 0){
				var Price = Math.round(unitPrice*PaperNumber*100)/100;		//费用保留小数点后两位
				Common_SetValue('txtCopyPrice',"复印费用：" + Price + '元');
			} else {
				Common_SetValue('txtCopyPrice','');
			}
		}
	}
	
	obj.btnBook_click = function(){
		var Error = '';
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID			= Common_GetValue('cboHospital');
		var CopyRecordID	= obj.VC_Input.RecordID;
		var PaperNumber		= Common_GetValue("txtPaperNumber");
		if (PaperNumber==''){
			Error = Error + '复印页数为空！';
		}
		if (Error)
		{
			ExtTool.alert("提示",Error);
			return;
		}

		var FeeInfo ="";									//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院	

		var CopyInfo = CopyRecordID;						//登记ID
			CopyInfo += '^' + PaperNumber;					//复印张数

		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","BO",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("错误提示","装订失败!");
			return;
		}else{
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
		}
	}
	
	obj.btnCancel_click = function(){
	    var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		var CopyInfo = obj.VC_Input.RecordID;				//登记ID
		
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","U",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("错误提示","作废失败!");
			return;
		}else{
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
		}
	}
	
	obj.btnCharge_click = function(){
		var CopyRecordID = obj.VC_Input.RecordID;
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		var CopyInfo = CopyRecordID;						//登记ID
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","CH",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("错误提示","收费失败!"+ret);
			return;
		}else{
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
			//TODO打印发票
			if (IsCopyPrintBill==1){
				PrintBill(ret,User,PayModeID);
			}
		}
	}
	
	obj.btnRetFee_click = function(){
		var CopyRecordID = obj.VC_Input.RecordID;
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = Common_GetValue('cboHospital');
		
		var CopyInfo = CopyRecordID;						//登记ID
		var PayModeID = 1;
		var FeeInfo =PayModeID;								//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院
		
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","CopyOper","RF",CopyInfo,FeeInfo,"^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("错误提示","退费失败!");
			return;
		}else{
			ExtTool.alert("提示","退费成功!");
			obj.EditViewport.close();
			Common_LoadCurrPage('gridCopy',1);
		}
	}
}