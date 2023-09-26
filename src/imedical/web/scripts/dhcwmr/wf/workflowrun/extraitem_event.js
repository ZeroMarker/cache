function EI_InitExtraItemEvent(obj){
	obj.EI_LoadEvent = function(){
		obj.EI_btnCancel.on("click",obj.EI_btnCancel_click,obj);
		obj.EI_btnSave.on("click",obj.EI_btnSave_click,obj);
	};
	
	obj.EI_btnSave_click = function(){
		var SubFlow = obj.EI_Arguments.SubFlow;
		var SysOpera = obj.EI_Arguments.SysOpera;
		objScreen.ExtraItemInput = ''
		
		//质控附加项
		if (SubFlow == 'Q'){
			if (SysOpera == 'H'){
				var QCReason = Common_GetValue("EI_txtQCReason");
				if (QCReason == '') {
					ExtTool.alert('提示','质控问题描述为空!');
					return;
				}
			}
			objScreen.ExtraItemInput = SubFlow + '|' + SysOpera
				+ CHR_1 + QCReason     //质控问题描述
		}
		
		//借阅附加项
		if (SubFlow == 'L'){
			var LUserName = Common_GetValue("EI_txtLUserName");
			var LUserCode = Common_GetValue("EI_txtLUserCode");
			var LLocTel = Common_GetValue("EI_txtLLocTel");
			var LUserTel = Common_GetValue("EI_txtLUserTel");
			var LPurpose = Common_GetValue("EI_cbgLPurpose");
			var LBackDate = Common_GetValue("EI_txtLBackDate");
			var LNote = Common_GetValue("EI_txtLNote");
			if (SysOpera == 'H'){
				if ((LUserName == '')&&(LUserCode == '')) {
					ExtTool.alert('提示','借阅人姓名与工号为空!');
					return;
				}
				if ((LLocTel == '')&&(LUserTel == '')) {
					ExtTool.alert('提示','借阅人电话与科室电话为空!');
					return;
				}
				if (LPurpose == '') {
					ExtTool.alert('提示','借阅目的为空!');
					return;
				}
				if (LBackDate == '') {
					ExtTool.alert('提示','预计归还日期为空!');
					return;
				}else{
					if (!obj.checkDate(LBackDate)){
						ExtTool.alert('提示','预计归还日期不能在今天之前!');
						return;
					}
				}
			}
			objScreen.ExtraItemInput = SubFlow + '|' + SysOpera
				+ CHR_1 + LLocTel                     //科室电话
				+ CHR_1 + LUserName                   //借阅人姓名
				+ CHR_1 + LUserCode                   //借阅人工号
				+ CHR_1 + LUserTel                    //借阅人电话
				+ CHR_1 + LPurpose                    //借阅目的
				+ CHR_1 + LBackDate                   //预计归还日期
				+ CHR_1 + LNote                       //借阅备注
		}
		
		//复印附加项
		if (SubFlow == 'C'){
			var ClientName = Common_GetValue("EI_txtClientName");
			var ClientRelation = Common_GetValue("EI_cboClientRelation");
			var CardType = Common_GetValue("EI_cboCardType");
			var PersonalID = Common_GetValue("EI_txtPersonalID");
			var Telephone = Common_GetValue("EI_txtTelephone");
			var Address = Common_GetValue("EI_txtAddress");
			var ClientNote = Common_GetValue("EI_txtClientNote");
			var CContent = Common_GetValue("EI_cbgCContent");
			var CPurpose = Common_GetValue("EI_cbgCPurpose");
			var CPageNumber = Common_GetValue("EI_txtCPageNumber");
			var CUnitPrice = Common_GetValue("EI_txtCUnitPrice");
			var CMoneyCount = Common_GetValue("EI_txtCMoneyCount");
			var CNote = Common_GetValue("EI_txtCNote");
			
			if ((SysOpera == 'R')||(SysOpera == 'H')){
				if (ClientName == '') {
					ExtTool.alert('提示','委托人为空!');
					return;
				}
				if (ClientRelation == '') {
					ExtTool.alert('提示','与患者关系为空!');
					return;
				}
				if (CardType == '') {
					ExtTool.alert('提示','证明材料为空!');
					return;
				}
				if (PersonalID == '') {
					ExtTool.alert('提示','证件号码为空!');
					return;
				}
				if (Telephone == '') {
					ExtTool.alert('提示','联系电话为空!');
					return;
				}
				if (CContent == '') {
					ExtTool.alert('提示','复印内容为空!');
					return;
				}
				if (CPurpose == '') {
					ExtTool.alert('提示','复印目的为空!');
					return;
				}
			}
			if (SysOpera == 'H'){
				if (CPageNumber == '') {
					ExtTool.alert('提示','复印页数为空!');
					return;
				}
			}
			objScreen.ExtraItemInput = SubFlow + '|' + SysOpera
				+ CHR_1 + ClientName                  //委托人
				+ CHR_1 + ClientRelation              //与患者关系
				+ CHR_1 + CardType                    //证明材料
				+ CHR_1 + PersonalID                  //证明号码
				+ CHR_1 + Telephone                   //联系电话
				+ CHR_1 + Address                     //联系地址
				+ CHR_1 + ClientNote                  //委托备注
				+ CHR_1 + CContent                    //复印内容
				+ CHR_1 + CPurpose                    //复印目的
				+ CHR_1 + CPageNumber                 //复印页数
				+ CHR_1 + CUnitPrice                  //复印单价
				+ CHR_1 + CMoneyCount                 //复印金额
				+ CHR_1 + CNote                       //复印备注
		}
		
		//封存附加项
		if (SubFlow == 'S'){
			var ClientName = Common_GetValue("EI_txtClientName");
			var ClientRelation = Common_GetValue("EI_cboClientRelation");
			var CardType = Common_GetValue("EI_cboCardType");
			var PersonalID = Common_GetValue("EI_txtPersonalID");
			var Telephone = Common_GetValue("EI_txtTelephone");
			var Address = Common_GetValue("EI_txtAddress");
			var ClientNote = Common_GetValue("EI_txtClientNote");
			var SContent = Common_GetValue('EI_cbgSContent');
			var SPurpose = Common_GetValue('EI_cbgSPurpose');
			var SCount = Common_GetValue('EI_txtSCount');
			var SDocCode = Common_GetValue('EI_txtSDocCode');
			var SDocName = Common_GetValue('EI_txtSDocName');
			var SMedUserName = Common_GetValue('EI_txtSMedUserName');
			var SMedUserCode = Common_GetValue('EI_txtSMedUserCode');
			var SNote = Common_GetValue('EI_txtSNote');
			
			if (SysOpera == 'H'){
				if (ClientName == '') {
					ExtTool.alert('提示','委托人为空!');
					return;
				}
				if (ClientRelation == '') {
					ExtTool.alert('提示','与患者关系为空!');
					return;
				}
				if (CardType == '') {
					ExtTool.alert('提示','证明材料为空!');
					return;
				}
				if (PersonalID == '') {
					ExtTool.alert('提示','证件号码为空!');
					return;
				}
				if (Telephone == '') {
					ExtTool.alert('提示','联系电话为空!');
					return;
				}
				if (SContent == '') {
					ExtTool.alert('提示','封存内容为空!');
					return;
				}
				if (SPurpose == '') {
					ExtTool.alert('提示','封存原因为空!');
					return;
				}
				if ((SDocName == '')&&(SDocCode == '')) {
					ExtTool.alert('提示','医师姓名与工号为空!');
					return;
				}
				if ((SMedUserName == '')&&(SMedUserCode == '')) {
					ExtTool.alert('提示','医务处人员姓名与工号为空!');
					return;
				}
			}
			objScreen.ExtraItemInput = SubFlow + '|' + SysOpera
				+ CHR_1 + ClientName                  //委托人
				+ CHR_1 + ClientRelation              //与患者关系
				+ CHR_1 + CardType                    //证明材料
				+ CHR_1 + PersonalID                  //证明号码
				+ CHR_1 + Telephone                   //联系电话
				+ CHR_1 + Address                     //联系地址
				+ CHR_1 + ClientNote                  //委托备注
				+ CHR_1 + SContent                    //封存内容
				+ CHR_1 + SPurpose                    //封存原因
				+ CHR_1 + SCount                      //封存数量
				+ CHR_1 + SDocCode                    //医师姓名
				+ CHR_1 + SDocName                    //医师工号
				+ CHR_1 + SMedUserName                //医务处人员姓名
				+ CHR_1 + SMedUserCode                //医务处人员工号
				+ CHR_1 + SNote                       //封存备注
		}
		
		obj.EI_WinExtraItem.close();
		objScreen.WorkFlowOperaByStep(2);
	}
	
	obj.EI_btnCancel_click = function(){
		obj.EI_WinExtraItem.close();
	}
	obj.checkDate = function(aDate)
	{
		var ret = 1;
		var arr=aDate.split('-');
		var myDate=new Date();
		var today=new Date();
		myDate.setFullYear(arr[0],arr[1]-1,arr[2]);
		if(myDate<today) ret = 0;
		return ret;
	}
}