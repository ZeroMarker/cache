//页面Event
function InitDicEditWinEvent(obj){
	//编辑窗体
	$('#winDicEdit').dialog({
		title: '字典维护',
		closed: true,
		modal: true,
		isTopZindex:false,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winDicEdit').close();
			}
		}]
	});
	
    obj.LoadEvent = function(args){
		$('#btnEdit').on('click', function(){
			var rd=obj.gridDictionary.getSelected();
			obj.layer(rd);
     	});
     	$('#btnTask').on('click', function(){
	     	obj.btnTask_click();
     	});
    }
	
	//单击事件
	obj.gridDictionary_onSelect = function (rd){
		if (rd["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnEdit").linkbutton("disable");
			$("#btnTask").linkbutton("enable");
			obj.gridDictionary.clearSelections();
		} else {
			obj.RecRowID = rd["ID"];
			$("#btnEdit").linkbutton("enable");
			$("#btnTask").linkbutton("disable");
		}
	}
	
	//双击编辑事件
	obj.gridDictionary_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//更新方法
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var TypeDr = $('#ulDicType').val();
		var RangeDr=$('#cboRange').combobox('getValue');
		var IsActive = ($("#chkIsActive").checkbox('getValue')? '1':'0');
		var ActDate = '';
		var ActTime = '';
		var ActUserID=session['DHCMA.USERID'];
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + TypeDr;
		inputStr = inputStr + CHR_1 + RangeDr;
		inputStr = inputStr + CHR_1 + IsActive;
		//inputStr = inputStr + CHR_1 + ActDate;
		//inputStr = inputStr + CHR_1 + ActTime;
		inputStr = inputStr + CHR_1 + ActUserID;
		var flg = $m({
			ClassName:"DHCMA.Util.EPS.DictionarySrv",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -2) {
				$.messager.alert("错误提示", "数据重复!Error=" + flg, 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winDicEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID == flg;
			obj.gridDictionary.reload();//刷新当前页
		}
	}
	
	//同步
	obj.btnTask_click = function(){
		$.messager.confirm("提示", "是否同步系统字典?", function (r) {
			if (r) {
				var flg = $m({
					ClassName:"DHCMA.Util.Task.SyncHisBaseDic",
					MethodName:"SyncDicData",
					aTypeDr:$('#ulDicType').val()
				},false);
				if (parseInt(flg) <= 0) {
					$.messager.alert("提示","同步字典错误！Error=" + flg, 'info');
				} else {
					$.messager.popover({msg: '同步字典成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridDictionary.reload() ;//刷新当前页
				}
			}
		});
	}
	
	//配置窗体-初始化
	obj.layer= function(rd){
		obj.cboRanger.reload()
		if(rd){
			obj.RecRowID =rd["ID"];
			var Code = rd["Code"];
			var Desc = rd["Desc"];
			var RangeID = rd["RangeID"]
			var IsActive = rd["IsActive"];
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboRange').combobox('setValue',RangeID);
			$('#chkIsActive').checkbox('setValue',(IsActive=="是"? true: false));
		}else{
			obj.RecRowID ='';
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboRange').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',false);
		} 
		$HUI.dialog('#winDicEdit').open();
	}	
}