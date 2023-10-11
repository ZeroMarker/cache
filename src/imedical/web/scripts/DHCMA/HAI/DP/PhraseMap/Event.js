function InitPhraseMapWinEvent(obj){
	//编辑窗体
	obj.InitDialog=function(){
		$('#layer').dialog({
			title: '常用短语对照编辑',
			iconCls:"icon-w-paper",
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
					$HUI.dialog('#layer').close();
				}
			}]
		});
	}
	
    obj.LoadEvent = function(args){
		$('#btnAdd').on('click', function(){
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridPhraseMap.getSelected();
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
    }
    //单击事件
	obj.gridPhraseMap_onSelect = function (rd,yindex){
		var yindex=yindex-1;
		if (rd["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridPhraseMap.clearSelections();
		} else {
			obj.RecRowID = rd["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	
	//双击编辑事件
	obj.gridPhraseMap_onDbselect = function(rd){
		obj.layer(rd);
	}
	//更新方法
	obj.btnSave_click = function(){
		var errinfo = "";
	    
		var PhraseCode = $('#txtCode').val();
		var PhraseDesc = $('#txtDesc').val();
		//var PhraseTypeDr=$('#ulPhraseType').tabs('getSelected')[0]['id'];
		var PhraseTypeDr  = $(".hisui-accordion ul>li.active")[0]['id'];
		//var MapDicDr = $('#cboMapDic').combobox('getText');
		var MapDicDr = $('#cboMapDic').combobox('getValue');
		var SCode = $('#txtSCode').val();
		var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
		var ActDate = '';
		var ActTime = '';
		var ActUser=session['LOGON.GROUPDESC'];
		
		if (!PhraseCode) {
			errinfo = errinfo + "短语代码不允许为空!<br>";
		}
		if (!PhraseDesc) {
			errinfo = errinfo + "短语名称不允许为空!<br>";
		}
		if (!PhraseTypeDr) {
			errinfo = errinfo + "短语分类不允许为空!<br>";
		}
		if (!SCode) {
			errinfo = errinfo + "子系统代码不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + PhraseCode;
		inputStr = inputStr + CHR_1 + PhraseDesc;
		inputStr = inputStr + CHR_1 + PhraseTypeDr;
		inputStr = inputStr + CHR_1 + MapDicDr
		inputStr = inputStr + CHR_1 + SCode;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + ActDate;
		inputStr = inputStr + CHR_1 + ActTime;
		inputStr = inputStr + CHR_1 + ActUser;
		console.log(inputStr);
		var flg = $m({
			ClassName:"DHCHAI.DP.PhraseMap",
			MethodName:"Update",
			InStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#layer').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			obj.gridPhraseMap.reload();//刷新当前页
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
					ClassName:"DHCHAI.DP.PhraseMap",
					MethodName:"DeleteById",
					Id:obj.RecRowID
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
					obj.gridPhraseMap.reload() ;//刷新当前页
				}
			}
		});
	}
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID 	= rd["ID"];
			var Code 		= rd["Code"];
			var Desc 		= rd["Desc"];
			var MapDicDesc 	= rd["MapDicDesc"];
			var MapDicDr 	= rd["MapDicDr"];
			
			var SCode		= rd["SCode"]
			var IsActive 	= rd["IsActive"];
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboMapDic').combobox('setValue',MapDicDr);
			$('#txtSCode').val(SCode);
			$('#chkActive').checkbox('setValue',(IsActive=="1"? true: false));
		}else{
			obj.RecRowID ='';
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboMapDic').combobox('setValue','');
			$('#txtSCode').val('');
			$('#chkActive').checkbox('setValue',false);
		} 
		//$HUI.dialog('#layer').open();
		$('#layer').show();
		obj.InitDialog()
	}

}