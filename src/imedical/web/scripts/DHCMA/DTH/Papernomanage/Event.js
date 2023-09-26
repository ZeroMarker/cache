//页面Event
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.QueryLoad();
		});
		//入库
		$('#btnSure').on('click', function(){
			obj.layer();
		});
    }
	//入库弹出框初始化
	$('#winProEdit').dialog({
		title: '死亡证明书入库',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		buttons:[{
			text:'确定',
			handler:function(){
				obj.btnSave_click();
				$HUI.dialog('#winProEdit').close();
			}
		},{
			text:'取消',
			handler:function(){
				$HUI.dialog('#winProEdit').close();
			}
		}]
	});
	//入库弹出框初始化
	$('#winProEdit1').dialog({
		title: '死亡证明书入库',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
	});
	obj.QueryLoad = function(){
		obj.gridPaperNo.load({
		    ClassName:"DHCMed.DTHService.PaperNoSrv",
			QueryName:"QryPaperNo",	
		    aState: $('#cboStatus').combobox('getValue'),
			aLoc: $('#cboLoc').combobox('getValue'),
			aHosp: $('#cboSSHosp').combobox('getValue'),
	    });		
	}
	obj.layer= function(){
		$('#StartNo').val('');
		$('#EndNo').val('');
		$HUI.dialog('#winProEdit').open();
	}
	obj.btnSave_click = function(){
		var errinfo = "";
		var separate="^";
		var StartNo = $('#StartNo').val();
		var EndNo = $('#EndNo').val();
		if (!StartNo) {
			errinfo = errinfo + "开始编码为空!<br>";
		}
		if (isNaN(StartNo)) {
			errinfo = errinfo + "开始编号格式错误，输入1~7位数字!<br>";
		}
		if (isNaN(EndNo)) {
			errinfo = errinfo + "结束编码格式错误，输入1~7位数字!<br>";
		}
		if (!EndNo) {
			errinfo = errinfo + "结束编码为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		if (EndNo<StartNo) {
			$.messager.alert("错误提示", "结束编码不能小于开始编码!<br>", 'info');
			return;
		}
		var CtlocId=session['LOGON.CTLOCID'];
		var UserID=session['LOGON.USERID'];
		var updateStr=StartNo+separate+EndNo+separate+CtlocId+separate+UserID;
		var ret = $m({                  
			ClassName:"DHCMed.DTHService.PaperNoSrv",
			MethodName:"ImportPaperNo",
			instr:updateStr
		},false);
		if(parseInt(ret)<=0){
			$.messager.alert("错误","入库错误!"+ret, 'error');
			return;
		}else{
			$HUI.dialog('#winProEdit').close();
			$HUI.dialog('#winProEdit1').open();
			$("div#Panel1").empty();
			while(ret.indexOf(separate)>0)
			{
			   ret=ret.replace(separate,'<br/>');
			}
			$("div#Panel1").append(ret);
			obj.gridPaperNo.reload();//刷新当前页   
		}
	}
}