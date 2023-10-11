//页面Event
function InitDicEditWinEvent(obj){
	//编辑窗体
	$('#winDicEdit').dialog({
		title: '产品字典维护',
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
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridDictionary.getSelected();
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		//管控数据医院授权点击事件				add by yankai20210730
		$('#btnAuthHosp').on('click',function(){
			Common_WinToAuthHosp(obj.RecRowID,"DHCMA_Util_BT.Dictionary","gridAuthHosp","winAuthHosp");	
		})
		/* for(var xindex=0;xindex<tabsLength;xindex++){
			$('#btnAdd'+xindex).on('click', function(){
				obj.layer();
			});
			$('#btnEdit'+xindex).on('click', function(){
				var rd=obj.gridDictionary.getSelected();
				obj.layer(rd);
			});
			$('#btnDelete'+xindex).on('click', function(){
				obj.btnDelete_click();
			});
		} */
    }
	
	//单击事件
	obj.gridDictionary_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["BTID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAuthHosp").linkbutton("disable");
			obj.gridDictionary.clearSelections();
		} else {
			obj.RecRowID = rd["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnAuthHosp").linkbutton("enable");
		}
		/* if (rd["BTID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd"+yindex).linkbutton("enable");
			$("#btnEdit"+yindex).linkbutton("disable");
			$("#btnDelete"+yindex).linkbutton("disable");
			obj.gridDictionary.clearSelections();
		} else {
			obj.RecRowID = rd["BTID"];
			$("#btnAdd"+yindex).linkbutton("disable");
			$("#btnEdit"+yindex).linkbutton("enable");
			$("#btnDelete"+yindex).linkbutton("enable");
		} */
	}
	
	//双击编辑事件
	obj.gridDictionary_onDbselect = function(rd){
		obj.layer(rd);
	}
	
	//更新方法
	obj.btnSave_click = function(){
		var errinfo = "";
		var myDate = new Date();
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var tab = $('#DicType').tabs('getSelected');
		var TypeDr = tab[0]['id'];
		var IndNo = $('#txtIndNo').val();
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		var ActDate = '';
		var ActTime = '';
		var ActUserID=session['DHCMA.USERID'];
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		var IsCheck = $m({
			ClassName:"DHCMA.Util.BTS.DictionarySrv",
			MethodName:"CheckPTCode",
			aTypeDr:TypeDr,
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + TypeDr;
		inputStr = inputStr + CHR_1 + IndNo
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + ActDate;
		inputStr = inputStr + CHR_1 + ActTime;
		inputStr = inputStr + CHR_1 + ActUserID;
		var flg = $m({
			ClassName:"DHCMA.Util.BT.Dictionary",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1,
			aHospID: $("#cboSSHosp").combobox('getValue')
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winDicEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridDictionary.reload();//刷新当前页
		}
	}
	//删除分类
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.Util.BT.Dictionary",
					MethodName:"DeleteById",
					aId:obj.RecRowID,
					aHospID: $("#cboSSHosp").combobox('getValue')
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridDictionary.reload() ;//刷新当前页
				}
			}
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID =rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];
			var IndNo=rd["BTIndNo"]
			var IsActive = rd["BTIsActive"];
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#txtIndNo').val(IndNo);
			$('#chkIsActive').checkbox('setValue',(IsActive=="是"? true: false));
		}else{
			obj.RecRowID ='';
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtIndNo').val('');
			$('#chkIsActive').checkbox('setValue',false);
		} 
		$HUI.dialog('#winDicEdit').open();
	}	
}