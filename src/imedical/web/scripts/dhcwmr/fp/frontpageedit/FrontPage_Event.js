function InitFrontPageEvent(obj){
	
    obj.LoadEvent = function(){
		obj.InitView();
	}
	
	obj.InitView = function(){
		obj.FPP_InitView();    //初始化病人基本信息
		obj.FPD_InitView();    //初始化诊断信息
		obj.FPO_InitView();    //初始化手术信息
		obj.FPE_InitView();    //初始化其他信息
		
		obj.btnSave = new Ext.Button({
			id : 'btnSave'
			,icon: '../scripts/dhcwmr/img/update.gif'
			,text : '<span style="font-weight:bold;color:red;font-size:16;">草稿</span>'
			,renderTo : 'btnSave'
			,width : 80
			,height : 30
		});
		obj.btnSubmit = new Ext.Button({
			id : 'btnSubmit'
			,icon: '../scripts/dhcwmr/img/save.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:16;">提交</span>'
			,renderTo : 'btnSubmit'
			,width : 80
			,height : 30
		});
		obj.btnClose = new Ext.Button({
			id : 'btnClose'
			,icon: '../scripts/dhcwmr/img/remove.png'
			,text : '<span style="font-weight:bold;color:#457294;font-size:16;">关闭</span>'
			,renderTo : 'btnClose'
			,width : 80
			,height : 30
		});
		obj.btnSave.on('click',obj.btnSave_onclick,obj);
		obj.btnSubmit.on('click',obj.btnSubmit_onclick,obj);
		obj.btnClose.on('click',obj.btnClose_onclick,obj);
		
		 //完成编目,不再暂存操作
		if (obj.FrontPage.IsFinish == 1){
			Common_SetDisabled('btnSave',true);
		}
		
		if ((obj.FrontPage.SubmitPower == 2)&&(obj.FrontPage.FrontPageID != '')) {		//add by niepeng 20150130 浏览权限不允许暂存和修改操作
			Common_SetDisabled('btnSave',true);
			Common_SetDisabled('btnSubmit',true);
		}
		
		Ext.ComponentMgr.all.each(function(cmp){
			var objTD = document.getElementById('Cmp_' + cmp.id);
			if (objTD) {
				cmp.setWidth(objTD.offsetWidth);
				cmp.render('Cmp_' + cmp.id);
			}
		});
		
		obj.FPE_InitData();  //初始化附加项目值
	}
	
	obj.DivExpand = function(divId){
		if (document.all[divId].style.display == 'none') {
			document.all[divId].style.display = 'block';
		} else {
			document.all[divId].style.display = 'none';
		}
	}
	
	obj.btnSave_onclick = function(){
		var flg = obj.SaveResult(0);
		if (!flg){
			ExtTool.alert("提示","保存错误!");
		} else {
			ExtTool.alert("提示","保存成功!");
		}
	}
	
	obj.btnSubmit_onclick = function(){
		var err_d = obj.FPD_CheckInput();
		var err_o = obj.FPO_CheckInput();
		var err_e = obj.FPE_CheckInput();
		if (err_d != ''){
			ExtTool.alert("诊断错误提示",err_d);
			return false;
		}
		if (err_o != ''){
			ExtTool.alert("手术错误提示",err_o);
			return false;
		}
		if (err_e != ''){
			ExtTool.alert("附加项错误提示",err_e);
			return false;
		}
		
		//无超级权限,不允许修改别人提交的编目数据,只允许修改自己提交的编目数据
		if ((obj.FrontPage.SubmitPower != 1)&&(obj.FrontPage.FrontPageID != '')) {
			var flg = ExtTool.RunServerMethod("DHCWMR.FPService.FrontPageSrv","CheckSubmitPower",obj.FrontPage.FrontPageID,session['LOGON.USERID']);
			if (parseInt(flg) < 1) {
				ExtTool.alert("提示","非超级权限,不允许修改他人已提交的病历!");
				return false;
			}
		}
		
		var flg = obj.SaveResult(1);
		if (!flg){
			ExtTool.alert("提示","保存错误!");
			return false;
		} else {
			ExtTool.alert("提示","提交成功!");
			Common_SetDisabled('btnSave',true); //完成编目,不再暂存操作
			obj.btnClose_onclick();  //update by zf 20150402 提交后自动关闭当前页面
			return true;
		}
	}
	
	obj.SaveResult = function(isFinish){
		var strFPInfo = obj.FrontPage.FrontPageID;  //编目ID
		strFPInfo += CHR_1 + obj.FrontPage.VolumeID;  //卷ID
		strFPInfo += CHR_1 + obj.FrontPage.FPType;  //类型
		strFPInfo += CHR_1 + obj.FrontPage.WFItemID;  //工作流项目
		strFPInfo += CHR_1 + isFinish;   //提交/保存
		strFPInfo += CHR_1 + session['LOGON.USERID'];   //操作用户
		strFPInfo += CHR_1 + '';  //备注
		var strFPDInfo = obj.FPD_GetInput(isFinish);
		var strFPOInfo = obj.FPO_GetInput(isFinish);
		var strFPEInfo = obj.FPE_GetInput(isFinish);
		var strPathRepInfo=""
		if (IsPathologEdit==1)
		{
			var strPathRepInfo = PathRepID;
			strPathRepInfo += CHR_1 + session['LOGON.USERID'];
		}
		var flg = ExtTool.RunServerMethod("DHCWMR.FPService.FrontPageSrv","SaveResult",strFPInfo,strFPDInfo,strFPOInfo,strFPEInfo,strPathRepInfo,"",LogonHospID);
		if (parseInt(flg) <= 0) {
			return false;
		} else {
			obj.FrontPage.FrontPageID = flg;
			obj.FrontPage.IsFinish = isFinish;
			obj.FPD_LoadFPQuery();
			obj.FPO_LoadFPQuery();
			obj.FPP_LoadFPQuery();
			//增加编码对照功能
			var flg = ExtTool.RunServerMethod("DHCWMR.FPService.FPMappingSrv","SynCodingInfo",obj.FrontPage.FrontPageID,obj.FrontPage.FPType,session['LOGON.USERID'],session['LOGON.HOSPID']);
			return true;
		}
	}
	
	obj.btnClose_onclick = function(){
		window.close();
	}
}