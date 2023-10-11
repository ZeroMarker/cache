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
		//删除
		$('#btnDel').on('click', function(){
			obj.Delete();
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
				//$HUI.dialog('#winProEdit').close();
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
		var patrn = /^(-)?\d+(\.\d+)?$/;
		var errinfo = "";
		var separate="^";
		var StartNo = $('#StartNo').val();
		var EndNo = $('#EndNo').val();
		if (!StartNo) {
			errinfo = errinfo + "开始编号为空!<br>";
		}
		if ((StartNo!="")&&(patrn.exec(StartNo)==null)) {
			errinfo = errinfo + "开始编号格式错误，输入1~7位数字!<br>";
		}
		if ((EndNo!="")&&(patrn.exec(EndNo)==null)) {
			errinfo = errinfo + "结束编码格式错误，输入1~7位数字!<br>";
		}
		if (StartNo.length>7){
			errinfo = errinfo + "开始编码长度大于七位，请修改!<br>";
		}
		if (EndNo.length>7){
			errinfo = errinfo + "结束编码长度大于七位，请修改!<br>";
		}
		if (!EndNo) {
			errinfo = errinfo + "结束编号为空!<br>";
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
	obj.Delete = function(){
		var rows = obj.gridPaperNo.getRows().length;  
		if (rows>0) {
			var length = obj.gridPaperNo.getChecked().length;
			if (length>0) {
				$.messager.confirm("删除", "仅能删除状态为[未分配]和[待用]的纸单号，确定提交并保存?", function (r) {
					if (r) {
						var rows=obj.gridPaperNo.getChecked();
					    for (var ind=0; ind<length;ind++) {
						    var tmpPaperNoID = rows[ind].PaperNoID;
						    var PaperNo = rows[ind].PaperNo;
						    var Status = rows[ind].Status;
							if ((Status!='未分配') && (Status!='待用')) {
								continue;
							}
							var ret = $m({                  
								ClassName:"DHCMed.DTH.PaperNo",
								MethodName:"DeleteObjById",
								id:tmpPaperNoID
							},false);
							if(parseInt(ret)<0){
								$.messager.alert("错误","纸单号删除失败!"+ret, 'error');
								break;
							}
						}
						if(parseInt(ret)>=0){
							$.messager.popover({ msg: "删除成功", type: 'info' });
							obj.gridPaperNo.reload();//刷新当前页
						}
					}
				});
			}
		}
	}
}