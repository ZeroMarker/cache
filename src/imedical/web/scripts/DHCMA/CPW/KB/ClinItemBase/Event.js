//页面Event
function InitCIBaseWinEvent(obj){
    obj.LoadEvent = function(args){
	    obj.TreeLoad()
	    //obj.gridEMRCodeLoad()
	    //添加
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
     	//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winCIBase').close();
	     	obj.CIBaseID="";
			obj.CICodeStr=""
			obj.CodeStr=""
			obj.HDEmrCodeStr=""
			obj.HDCodeStr=""
	     	obj.TreeLoad()
     	});
     	//修改
		$('#btnEdit').on('click', function(){
			var rd=obj.gridClinItemBase.getSelected()
			obj.layer(rd);	
		});
     	//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		}); 
    }
    //双击诊疗事件
	obj.gridClinItemBase_onDbselect = function(rd){
		obj.layer(rd);
	}
    //单击诊疗事件
	obj.gridClinItemBase_onSelect = function (){
		var rowData = obj.gridClinItemBase.getSelected();
		if (rowData["BTID"] == obj.CIBaseID) {
			$("#btnAdd").linkbutton("enable"); 
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.CIBaseID="";
			obj.CICodeStr=""
			obj.CodeStr=""
			obj.HDEmrCodeStr=""
			obj.HDCodeStr=""
			obj.gridClinItemBase.clearSelections();
			obj.TreeLoad();
		}
		else {
			obj.CIBaseID = rowData["BTID"];
			$('#TreeSearch').searchbox('setValue',"")
			obj.CICodeStr=rowData["BTEMRCode"]
			var ret = $m({
				ClassName:"DHCMA.CPW.KBS.ClinItemBaseSrv",
				MethodName:"GetEmrCode",
				aCode:rowData["BTEMRCode"]
			},false);
			if (ret!=""){
				 obj.CodeStr=ret.split("^")[0]
				 obj.HDEmrCodeStr=ret.split("^")[1]
				 obj.HDCodeStr=ret.split("^")[2]
			}else{
				obj.CodeStr=""
				obj.HDEmrCodeStr=""
				obj.HDCodeStr=""
			}
			obj.TreeLoad()
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存诊疗
	obj.btnSave_click = function(){
		var errinfo = "";
		var Desc = $('#Desc').val();
		var EMRCode = $('#EMRCode').val();
		var IsActive = $("#IsActive").checkbox('getValue')? '1':'0';
		 if (!Desc){
		    var errinfo = errinfo +  "请填写项目描述!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.KB.ClinItemBase",
			MethodName:"CheckKBDesc",
			aDesc:Desc,
			aID:obj.CIBaseID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "描述与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.CIBaseID;
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + EMRCode;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + "";
		inputStr = inputStr + "^" + session['DHCMA.USERID'];
		var TRet=$m({
			ClassName :"DHCMA.CPW.KB.ClinItemBase",
			MethodName:"Update",
			aInputStr :inputStr,
			aSeparete:"^"
		},false)
		if (parseInt(TRet)>0) {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winCIBase').close()
			obj.CIBaseID="";
			obj.CICodeStr=""
			obj.CodeStr=""
			obj.HDEmrCodeStr=""
			obj.HDCodeStr=""
			obj.gridClinItemBase.reload();
			obj.TreeLoad()
		}else{
			$.messager.alert("错误提示", "更新数据错误!Error=" + TRet, 'info');
		}
	}
	//删除诊疗
	obj.btnDelete_click = function(){
		if (obj.CIBaseID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.KB.ClinItemBase",
					MethodName:"DeleteById",
					aId:obj.CIBaseID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');					
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.CIBaseID="";
					obj.CICodeStr=""
					obj.CodeStr=""
					obj.HDEmrCodeStr=""
					obj.HDCodeStr=""
					obj.gridClinItemBase.reload() ;//刷新当前页
					obj.TreeLoad()
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.CIBaseID = rd["BTID"];
			var Desc = rd["BTDesc"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=="是"? true: false)
			var EMRCode = rd["BTEMRCode"];
			$('#Desc').val(Desc);
			$('#EMRCode').val(EMRCode);
			$('#IsActive').checkbox('setValue',IsActive);
		}else{
			obj.CIBaseID = "";
			$('#Desc').val('');
			$('#EMRCode').val('');
			$('#IsActive').checkbox('setValue',false);
		}
		//var left=$("#btnEdit").offset().left+5;
		//$HUI.dialog('#winCIBase').open().window("move",{left:left});
		$HUI.dialog('#winCIBase').open();
	}
}