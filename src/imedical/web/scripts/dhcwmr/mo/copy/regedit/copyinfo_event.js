function BC_InitInfoEvent(obj){
	
	obj.BC_LoadEvents = function(){
		obj.BC_btnCancel.on("click",obj.BC_btnCancel_click,obj);
		obj.BC_btnSave.on("click",obj.BC_btnSave_click,obj);
	}
	obj.BC_btnCancel_click = function(){
		obj.BC_WinCopy.close();
	}

	obj.BC_btnSave_click = function(){
		var Error='';
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("提示",'病案类型为空!');
			return;
		}
		var ClientName = Common_GetValue("BC_ClientName");
		var ClientRelation = Common_GetValue("BC_cboClientRelation");
		var CardType = Common_GetValue("BC_cboCardType");
		var PersonalID = Common_GetValue("BC_txtPersonalID");
		var Telephone = Common_GetValue("BC_txtTelephone");
		var Address = Common_GetValue("BC_txtAddress");
		var Purpose = Common_GetValue("BC_cbgPurpose");
		var Content = Common_GetValue("BC_cbgContent");
		var Resume = Common_GetValue("BC_txtResume");
		var User   = session['LOGON.USERID'];
		var Loc	   = session['LOGON.CTLOCID'];
		var GroupID= session['LOGON.GROUPID'];
		var HospID = session['LOGON.HOSPID'];
		
		if (Purpose != "") Purpose = Purpose.replace(/,/g,'#');
		if (Content != "") Content = Content.replace(/,/g,'#');
		//var OperaList = objScreen.GetOperaList();
		if (ClientName=="") Error=Error+"委托人、";
		if (ClientRelation=="") Error=Error+"与患者关系、";
		if (CardType=="") Error=Error+"证明材料、";
		if (PersonalID=="") Error=Error+"证件号码、";
		if (Telephone=="") Error=Error+"联系电话、";
		if (Purpose=="") Error=Error+"复印目的、";
		if (Error!=""){
			ExtTool.alert("提示",Error+"为空！");
			return;
		}
		
		var CopyInfo="";
			CopyInfo += '^' + ClientName;					//委托人姓名
			CopyInfo += '^' + ClientRelation;				//委托人与患者关系
			CopyInfo += '^' + CardType;						//委托人证明材料
			CopyInfo += '^' + PersonalID;					//委托人身份证号
			CopyInfo += '^' + Telephone;					//委托人联系电话
			CopyInfo += '^' + Address;						//委托人联系地址
			CopyInfo += '^' + Content;						//复印内容
			CopyInfo += '^' + Purpose;						//复印目的
			CopyInfo += '^' + Resume;						//复印备注
		
		var FeeInfo ="";									//支付方式
			FeeInfo += '^'+User;							//操作员
			FeeInfo += '^'+Loc;								//登陆科室
			FeeInfo += '^'+GroupID;							//登陆安全组
			FeeInfo += '^'+HospID;							//登陆医院		
			
		var ret = ExtTool.RunServerMethod("DHCWMR.MOService.CopyRecordSrv","BatchCopy","RE",obj.Records,CopyInfo,FeeInfo,"^");
		if (ret>0){
			ExtTool.alert("提示","保存成功!",Ext.MessageBox.INFO,Ext.MessageBox.OK,function(button){
				if (button=='ok'){
					obj.BC_WinCopy.close();
					Common_LoadCurrPage('gridCopy',1);
					objScreen.btnQuery_click();
				}
			});
		}
		Common_SetValue("txtMrNo",'')	
	}
}