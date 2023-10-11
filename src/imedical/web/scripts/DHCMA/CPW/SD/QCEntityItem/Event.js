//页面Event
function InitWinEvent(obj){
	obj.RecRowID="",obj.VerItemID="",obj.ItemDicId=""
    obj.LoadEvent = function(args){ 
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer()
     	});
     	
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridQCEntityItem.getSelected()
			if (rd) {
				obj.layer(rd);
			}
			else {
				$.messager.alert("提示", "请选中行，再行修改！", 'info');
				return;
			}		
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winQCEntityItem').close();
     	});
     	
     	//校验规则按钮事件
     	//添加
     	$('#btnAddR').on('click', function(){
			obj.addNewRule();
     	});
     	//保存
		$('#btnSaveR').on('click', function(){
	     	obj.btnSaveR_click();
     	});
		//删除
		$('#btnDeleteR').on('click', function(){
	     	obj.btnDeleteR_click();
     	});
     	///历史表单对照
     	//自动对照
     	$('#btnAutoMatch').on('click', function(){
			obj.btnAutoMatch_click();
     	});
     	//手工对照
     	$('#btnMatch').on('click', function(){
			obj.btnMatch_click();
     	});
     	//已对照
     	$('#btnMatched').on('click', function(){
			obj.gridQCEntityItemVer.load({
					ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
					QueryName:"QryQCEntityItem",
					aParRef:obj.ParrefID,
					aVersion:obj.HisVerID,
					aMatched:1	
					});
     	});
     	//未对照
     	$('#btnNoMatch').on('click', function(){
			obj.gridQCEntityItemVer.load({
					ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
					QueryName:"QryQCEntityItem",
					aParRef:obj.ParrefID,
					aVersion:obj.HisVerID,
					aMatched:0	
					});
     	});
     	//撤销对照
     	$('#btnCancel').on('click', function(){
			obj.btnCancel_click();
     	});
     	//查看对照项目值域差异
     	$('#btnItemAlias').on('click', function(){
			obj.btnItemAlias_click();
     	});
     	//导出项目值域差异
     	$('#btnDifExport').on('click', function(){
			ExportGridByCls(obj.DicDifGrid,"项目值域差异明细")
     	});
     	///项目数据源标准化取值配置
     	//保存配置信息
     	$('#StandSv').on('click', function(){
			obj.btnStandSv_click();
     	});
     	//重置配置信息
     	$('#StandReset').on('click', function(){
			obj.btnStandReset_click();
     	});
     }
     obj.btnAutoMatch_click=function(){
	     $m({
		  ClassName:'DHCMA.CPW.SDS.QCEntityItemVerSrv',
		  MethodName:'MatchQCItem',
		  aParRef:obj.ParrefID,
		  aVersion:obj.HisVerID,
		  aAutoMatch:1 
		  },function(ret){
			  if (parseInt(ret)>0) {
				$.messager.popover({msg: '自动对照'+ret+'条项目！',type:'success',timeout: 2000});
			  }else{
				$.messager.popover({msg: '没有可自动对照的项目！',type:'error',timeout: 2000});
			}
		})
		obj.gridQCEntityItemVer.reload();
	 }
	 obj.btnMatch_click=function(){
	     $m({
		  ClassName:'DHCMA.CPW.SDS.QCEntityItemVerSrv',
		  MethodName:'MatchQCItem',
		  aParRef:obj.ParrefID,
		  aItemID:obj.ItemID,
		  aItemVerID:obj.VerItemID
		  },function(ret){
			  if (parseInt(ret)>0) {
				$.messager.popover({msg: '成功对照'+ret+'条项目！',type:'success',timeout: 2000});
			  }else{
				$.messager.popover({msg: '项目对照失败！',type:'error',timeout: 2000});
			}
		})
		obj.gridQCEntityItemVer.reload();
		obj.VerItemID="";
	 }
	 obj.btnCancel_click=function(){
	     $m({
		  ClassName:'DHCMA.CPW.SDS.QCEntityItemVerSrv',
		  MethodName:'CancelMatchQCItem',
		  aItemVerID:obj.VerItemID
		  },function(ret){
			  if (parseInt(ret)>0) {
				$.messager.popover({msg: '取消项目对照成功！',type:'success',timeout: 2000});
			  }else{
				$.messager.popover({msg: '取消对照失败！'+ret,type:'error',timeout: 2000});
			}
		})
		obj.gridQCEntityItemVer.reload();
		obj.VerItemID="";
	 }
    $('#ItemKey').searchbox({
	    searcher:function(value,name){
		    obj.gridQCEntityItemLoad();
	    },
	    prompt:'请输入描述/代码'
	});	
	$('#ItemVerKey').searchbox({
	    searcher:function(value,name){
	    	obj.gridQCEntityItemVer.load({
					ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
					QueryName:"QryQCEntityItem",
					aParRef:obj.ParrefID,
					aVersion:obj.HisVerID,
					aKey:value		
					});
	    },
	    prompt:'请输入关键字/代码'
	});	
	obj.gridQCEntity_onSelect = function (rd){
		$('#ItemKey').searchbox('setValue',"")
		obj.gridQCEntityItem.loadData([]);
		obj.QCVersion.clear();
		obj.ParrefID=rd["BTID"]
		obj.QCVersion.select(rd.CurVerID)
	}
	obj.gridQCEntityItem_onDbselect= function (rd){
		obj.layer(rd);
	}
	obj.gridQCEntityItem_onSelect= function (rd){
		obj.ItemID=rd.BTID
		$("#btnEdit").linkbutton("enable");
		$("#btnDelete").linkbutton("enable");
	}
	obj.gridQCEntityItemVer_onSelect= function (rd){
		obj.VerItemID=rd.BTID
	}
	obj.gridQCEntityItemLoad = function(){
		$cm ({
			ClassName:'DHCMA.CPW.SDS.QCEntityItemSrv',
			QueryName:'QryQCEntityItem',
			ResultSetType:"Array",
			aParRef:obj.ParrefID,
			aVersion:2,
			aKey:$('#ItemKey').searchbox('getValue'),
			page:1,      //可选项，页码，默认1			
			rows:9999   //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridQCEntityItem').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);			
		})

    }
	//保存项目
	obj.btnSave_click = function(flg){
		var errinfo = "";
		var Code = $('#BTCode').val();
		var Desc = $('#BTDesc').val();
		var Type = $('#BTType').combobox('getValue');
		var Express=$('#BTExpress').combobox('getValue');
		var IsActive = $('#BTIsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		var IndNo = $('#IndNo').val();
		var LinkItem = $('#BTLinkItem').combobox('getValue');
		if (typeof(LinkItem)=='undefined') LinkItem=""
		var TriggerCondition = $('#TriggerCondition').val();
		var BTExpressParam = '';
		var BTResume = $('#BTResume').val();
		var UpType = $('#BTUpType').combobox('getValue');
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述为空!<br>";
		}	
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr=obj.ParrefID
		if (obj.ParrefID=="") {
			$.messager.alert("错误提示", "质控病种ID为空，无法保存项目内容！", 'info');
			return;
		}
		var ItemCat  = $('#BTCat').val();
		var ItemSubCat  = $('#BTSubCat').val();
		var Needed   = $('#BTIsNeeded').checkbox('getValue');
		var GetDataParam = $('#GetDataParam').combobox('getText');
		Needed = (Needed==true? 1: 0);
		inputStr = inputStr + String.fromCharCode(1) +obj.RecRowID;
		inputStr = inputStr + String.fromCharCode(1) + Code;
		inputStr = inputStr + String.fromCharCode(1) + Desc;
		inputStr = inputStr + String.fromCharCode(1) + Type;
		inputStr = inputStr + String.fromCharCode(1) + Express;
		inputStr = inputStr + String.fromCharCode(1) + IsActive;
		inputStr = inputStr + String.fromCharCode(1) + IndNo
		inputStr = inputStr + String.fromCharCode(1) + LinkItem
		inputStr = inputStr + String.fromCharCode(1) + TriggerCondition;
		inputStr = inputStr + String.fromCharCode(1) + BTExpressParam
		inputStr = inputStr + String.fromCharCode(1) + Needed
		inputStr = inputStr + String.fromCharCode(1) + ItemCat
		inputStr = inputStr + String.fromCharCode(1) + GetDataParam
		inputStr = inputStr + String.fromCharCode(1) + ItemSubCat
		inputStr = inputStr + String.fromCharCode(1) + UpType
		inputStr = inputStr + String.fromCharCode(1) + BTResume
		inputStr = inputStr + String.fromCharCode(1) + obj.QCVerID
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.QCEntityItem",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:String.fromCharCode(1)
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winQCEntityItem').close();
			obj.gridQCEntityItemLoad()
			//obj.gridQCEntityItem.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridQCEntityItem.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.SD.QCEntityItem",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("错误提示","系统参数配置不允许删除！", 'info');
					} else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.gridQCEntityItemLoad()
					//obj.gridQCEntityItem.reload() ;//刷新当前页	
				}
			} 
		});
	}
	//检验规则函数事件
	obj.addNewRule=function(){
		$('#RuleGrid').datagrid('appendRow',{RowID:'',QCExpressID:'',QCExpress:'',RuleExpress:'',RuleType:'error',RuleContent:''});
      	editIndex = $('#RuleGrid').datagrid('getRows').length - 1;
        $('#RuleGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
        $("#btnSaveR").linkbutton('enable');
		$("#btnDeleteR").linkbutton('enable');	
	}
	obj.btnSaveR_click=function(){
		var Editrows=$('#RuleGrid').datagrid('getSelections')
		for (var i=0;i<Editrows.length;i++) {
			var rowIndex=$('#RuleGrid').datagrid('getRowIndex',Editrows[i])
			$('#RuleGrid').datagrid('endEdit',rowIndex)
		}
		var rows=$('#RuleGrid').datagrid('getChanges');
		var Err="";
		for (var i=0;i<rows.length;i++) {
			var rec=rows[i]
			var InputStr=obj.ItemID
			InputStr+="^"+rec.RowID
			InputStr+="^"+rec.RuleType
			InputStr+="^"+rec.QCExpressID
			InputStr+="^"+rec.RuleExpress
			InputStr+="^"+rec.RuleContent
			$m({
					ClassName:"DHCMA.CPW.SD.QCItemValidRule",
					MethodName:"Update",
					aInputStr:InputStr
					},function(flg){
						if (flg<0) {
							Err=Err+"第"+(i+1)+"行数据保存错误.<br>"
							}
					}
			)
		}
		
		if (Err!="") {				
				$.messager.alert("错误提示", Err, 'info');
		}else{
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000})	
		}	
		obj.RuleGrid.reload()
	}
	obj.btnDeleteR_click=function(){
		var Editrows=$('#RuleGrid').datagrid('getSelections');
		for (var i=0;i<Editrows.length;i++) {
			var row=Editrows[i];
			if (row.RowID) {
				$.messager.confirm("删除", "是否删除已保存规则:"+row.RuleContent, function (r) {	
					if (r) {			
						var flg = $m({
							ClassName:"DHCMA.CPW.SD.QCItemValidRule",
							MethodName:"DeleteById",
							aId:row.RowID
						},false)
						if (parseInt(flg)==-777) {
							$.messager.alert("错误提示","系统参数配置不允许删除！", 'info');
							return;
						} 
						obj.RuleGrid.reload();
					}
				})
			}
		}
		obj.RuleGrid.reload();
	}
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			obj.BTLinkItem=$HUI.combobox("#BTLinkItem",{
				url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryQCEntityItem&ResultSetType=Array&aParRef='+obj.ParrefID,
				valueField:'BTID',
				textField:'BTDesc',
			})
			$("#BTCode").val(rd["BTCode"])
			$("#BTDesc").val(rd["BTDesc"])
			$('#BTType').combobox('setValue', rd["BTTypeID"]);	
			$('#BTUpType').combobox('setValue', rd["BTUpTypeID"]);		
			$("#BTExpress").combobox('setValue', rd["BTExpressDr"]);
			$("#IndNo").val(rd["BTIndNo"])
			$("#BTLinkItem").combobox('setValue', rd["BTLinkedItem"]);	
			$("#TriggerCondition").val(rd["BTTriggerCondition"])
			$("#BTIsActive").checkbox('setValue',rd["BTIsActive"]=="是"?true:false)
			$("#BTResume").val(rd["BTResume"])
			$("#BTCat").val(rd["BTItemCat"]);
			$("#BTSubCat").val(rd["BTItemSubCat"]);
			if (rd["BTExpressCode"]=="BaseInfo") {
					$HUI.combobox("#GetDataParam",{
						url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryClassProperty&ResultSetType=Array&aClassName=DHCMA.Util.EPx.Episode',
						valueField:'PropertyName',
						textField:'PropertyName',	
					})
				}else{
					$('#GetDataParam').combobox('loadData', {});
				}
			$("#BTIsNeeded").checkbox('setValue',rd["BTIsNeeded"]=="是"?true:false)
			$("#GetDataParam").combobox('setValue',rd["GetDataParam"])
			
		}else{
			obj.RecRowID="";
			$("#BTCode").val('');
			$("#BTDesc").val('');
			$("#BTType").combobox('setValue','');
			$("#BTUpType").combobox('setValue','');
			$("#BTExpress").combobox('setValue','');
			$("#IndNo").val('');
			$("#BTLinkItem").combobox('setValue','');
			$("#TriggerCondition").val('');
			$("#BTIsActive").checkbox('uncheck');
			$("#TriggerCondition").val('');	
			$("#BTResume").val('');
			$("#BTCat").val('');	
			$("#BTSubCat").val('');
			$("#BTIsNeeded").val('');
			$("#GetDataParam").val('');
		}
		$HUI.dialog('#winQCEntityItem').open();
	}
	obj.ShowItemStand=function(ItemID) {
		obj.InitConfigData(ItemID);
		$HUI.dialog('#winQCItemMatch').open();
	}
	obj.ShowItemRule=function(ItemID) {
		obj.RuleGrid = $HUI.datagrid("#RuleGrid",{
			fit:true,
			singleSelect: false,
			autoRowHeight: false,
			striped:true,
			rownumbers:true, 
			loadMsg:'数据加载中...',
		    url:$URL,
		    nowrap:false,
		    queryParams:{
			    ClassName:"DHCMA.CPW.SDS.QCItemValidRuleSrv",
				QueryName:"QryQCItemVRule",
				aItemDr:ItemID
		    },
			columns:[[
				{field:'QCExpressID',title:'函数',width:'120',
				formatter:function(v,r){					
						return r.QCExpress
						},
				editor:{
						type:'combobox',
						panelHeight:"auto",
						options:{
							url:$URL+"?ClassName=DHCMA.CPW.SDS.QCExpressSrv&QueryName=QryQCExpress&ResultSetType=Array&aExpType=ValiRule",
							selectOnNavigation:true,
							valueField:'BTID',
							textField:'BTDesc',
							onSelect:function(rd){
							}
						}
					}
				},
				{field:'RuleExpress',title:'表达式',width:'250',
					editor:{
							type:'text'
					}
				},
				{field:'RuleType',title:'级别',align:'center',width:'100',
					formatter:function(v,r){					
						return r.RuleTypeDesc
						},
					editor:{
			                type:'combobox',
							options:{
								valueField:'id',
								textField:'text',
								selectOnNavigation:true,
								panelHeight:"auto",
								editable:false,
								data:[
									{id:'info',text:'温馨提示'},
									{id:'warning',text:'指标预警'},
									{id:'error',text:'填报错误'},
									{id:'stop',text:'终止填报'}
									
								]
							}
				}
				},
				{field:'RuleContent',title:'提示内容',width:'300',
				editor:{
							type:'text'
					}
				}
			]]
			,onClickRow:function(index,rowData){
				$("#btnSaveR").linkbutton('enable');
				$("#btnDeleteR").linkbutton('enable');
				$('#RuleGrid').datagrid('selectRow', index).datagrid('beginEdit', index);;
			}
			,onLoadSuccess:function(rowIndex,rowData){
			}
		});
		$HUI.dialog('#winQCItemRule').open();
	}
	obj.btnItemAlias_click=function(){
	 	obj.DicDifGrid = $HUI.datagrid("#DicDifGrid",{
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			fit:true,
			singleSelect: true,
			//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			autoRowHeight: false, 
			loadMsg:'数据加载中...',
		    url:$URL,
		    queryParams:{
			    ClassName:"DHCMA.CPW.SDS.QCEntityItemVerSrv",
				QueryName:"QryVerItemDicDif",
				aParRef:obj.ParrefID,
				aVersion:obj.HisVerID
		    },
			columns:[[
				{field:'ItemCode',title:'质控代码',width:'120'},
				{field:'ItemDesc',title:'质控项目',width:'120',showTip:true},
				{field:'DifMessage',title:'差异明细',width:'520',showTip:true,tipWidth:450}

			]]
			,onBeforeLoad:function(){

			}
			,onLoadError:function(e){
				$.messager.alert("提示",e.responseText, 'info');
			}
			,onLoadSuccess:function(){

			}
		});
		$HUI.dialog('#winQCItemDicDif').open()    
	 }
	//数据源标准化配置事件
	obj.btnStandSv_click=function(){	
		var SoureceId	= Common_GetValue('Source')
		var GetField	= Common_GetValue('GetField')
		var StandDic	= Common_GetValue('StandDic')
		var StandDicSub	= Common_GetValue('StandDicSub')
		var GetTiming	= Common_GetValue('GetTiming')
		var CalExp		= Common_GetValue('CalExp')
		var DataFormat	= Common_GetValue('DataFormat')
		if (SoureceId=="") {
			$.messager.alert("提示","请选择数据源进行配置！", 'info');
			return
		}
		InputStr="^"
		InputStr+=obj.ItemID+"^"
		InputStr+=obj.ItemDicId+"^"
		InputStr+=SoureceId+"^"
		InputStr+=GetField+"^"
		InputStr+=StandDic+"^"
		InputStr+=StandDicSub+"^"
		InputStr+=GetTiming+"^"
		InputStr+=CalExp+"^"
		InputStr+=DataFormat
		$m({
			ClassName:'DHCMA.CPW.SD.QCItemDataConfig',
			MethodName:'Update',
			aInputStr:InputStr	
		},function(flg){
			if (parseInt(flg)<1) {
				$.messager.alert("错误提示", "保存失败，请联系信息科!" , 'info');
			}else {
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				$HUI.dialog('#winQCItemMatch').close();
			}	
		})
	}
	obj.btnStandReset_click=function(){
		var InputStr=obj.ItemID
		$.messager.confirm("重置", "是否重置该条数据配置信息?", function (r) {		
			if(r){
				$m({
					ClassName:'DHCMA.CPW.SDS.QCItemDataConfigSrv',
					MethodName:'ResetConfig',
					aInputStr:InputStr	
				},function(flg){
					if (parseInt(flg)<0) {
						$.messager.alert("错误提示", "重置失败，请联系信息科!" , 'info');
					}else {
						$.messager.popover({msg: '重置成功！',type:'success',timeout: 1000});
					}
				})
				obj.ClearMatchData()
			}
		})
	}
	obj.InitConfigData=function(ItemID){
		var Condata=$m({
			ClassName:'DHCMA.CPW.SDS.QCItemDataConfigSrv',
			MethodName:'GetConfigData',
			aInputStr:ItemID
		},false)
		ConfigData=[]
		if (Condata.length==0) {obj.ClearMatchData();return;}
		ConfigData=Condata.split('^')
		obj.Source.select(ConfigData[0]);
		obj.StandDic.select(ConfigData[2]);
		obj.StandDicSub.select(ConfigData[3]);
		obj.GetField.select(ConfigData[1]);	
		obj.GetTiming.setValue(ConfigData[4]);
		$('#CalExp').val(ConfigData[5]);
		$('#DataFormat').val(ConfigData[6]);	
	}
	obj.ClearMatchData=function(){
		obj.Source.setValue('');
		obj.GetField.setValue('');
		obj.StandDic.setValue('');
		obj.StandDicSub.setValue('');
		obj.GetTiming.setValue('');
		$('#CalExp').val('');
		$('#DataFormat').val('');
		obj.GetField.loadData([]);
		obj.StandDic.loadData([]);
		obj.StandDicSub.loadData([]);
	}
}