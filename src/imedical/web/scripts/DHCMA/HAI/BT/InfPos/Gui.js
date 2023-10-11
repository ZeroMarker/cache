//页面Gui
var obj = new Object();
function InitInfPosWin(){
	obj.RecRowID = "";
	//感染诊断（部位）列表
	obj.gridInfPos = $HUI.datagrid("#gridInfPos",{
		fit: true,
		title: "感染诊断（部位）",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		sortName:'ID',
		sortOrder:'asc',
		remoteSort:false,    //是否是服务器对数据排序
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:80,sortable:true,sorter:Sort_int},
			{field:'Code',title:'代码',width:100},
			{field:'Desc',title:'名称',width:350},
			{field:'expander',title:'诊断依据',width:100,
				formatter: function ( value,row,index ) {
					if (row['DiagFlag'] != '1') {
						return '';
					} else {
						return '<a href="#" onclick=obj.openInfPos('+row['ID']+')>诊断依据</a>';
					}
				}
			},
			{field:'DiagFlag',title:'诊断标志',width:100,
				formatter: function ( value,row,index ) {
					return (row['DiagFlag'] == '1' ? '是' : '否');
				}
			},
			{field:'GCode',title:'层级编码',width:100},
			{field:'IsActive',title:'是否有效',width:100,
				formatter: function ( value,row,index ) {
					return (row['IsActive'] == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridInfPos_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridInfPos_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			//加载成功
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});

	//状态checkbox
   obj.chkInfSub = function() {
	    $("#chkInfSubList").empty();
	   	var strList =$m({
			ClassName:"DHCHAI.BTS.InfSubSrv",
			QueryName:"QryInfSubByPosID",
			ResultSetType:'array',
			aPosID:obj.RecRowID,
			aCheckAll:($('#checkAll').checkbox('getValue')?1:0),
	 	},false);
	 
	 	var objStr = JSON.parse(strList);
		var len = objStr.length;
		if (len<1) return;
	
		for (var dicIndex = 0; dicIndex < len; dicIndex++) {
			var DicID = objStr[dicIndex].ID;
			var DicDesc = objStr[dicIndex].Desc;
			var IsChecked = objStr[dicIndex].IsChecked;
			
			$("#chkInfSubList").append(
				 "<div style='float:left;width:100%;line-height:35px;'><input id="+DicID+" type='checkbox' class='hisui-checkbox' "+(IsChecked==1? "checked='checked'":"")+" label="+DicDesc+" name='chkInfSub' value="+DicID+" ></div>"
			);
		}
		$.parser.parse("#chkInfSubList");  //解析checkbox
		
	
	    $HUI.checkbox("[name='chkInfSub']",{  
			onChecked:function(e,value){				
				var InfSubDesc = $(e.target).attr("label");   //关联
				var InfSubID = $(e.target).attr("value");
				if (obj.RecRowID){
					var rowData = obj.gridInfPos.getSelected();
			    	var InfPosDesc = rowData["Desc"];
			    	var DiagFlag = rowData["DiagFlag"];
			    	if (DiagFlag=="0"){
				    	this.checked=false;
				    	$.messager.alert("提示","感染部位不能关联诊断分类！",'info');
				    	return;
				    }
				   
			    	var inputStr=InfPosDesc+"^"+InfSubDesc;
			    	var flg =$m({
						ClassName:"DHCHAI.BTS.InfPosSrv",
						MethodName:"ImportInfDiagMap",
						aInput:inputStr,
						aSeparate:"^"
				 	},false);
			    	if (parseInt(flg) <= 0) {
						$.messager.alert("提示","关联感染诊断分类错误!",'info');
						return;
					}
			    }else{
				    this.checked=false;
				    $.messager.alert("提示","请先选择感染诊断!",'info');
					return;
				}
								
			},onUnchecked:function(e,value){				
				var InfSubDesc = $(e.target).attr("label");   //取消关联  
				var InfSubID = $(e.target).attr("value");
				var rowData = obj.gridInfPos.getSelected();
			    var InfPosDesc = rowData["Desc"];
			    
			    var inputStr=InfPosDesc+"^"+InfSubDesc;
				var flg =$m({
					ClassName:"DHCHAI.BTS.InfPosSrv",
					MethodName:"CancelInfDiagMap",
					aInput:inputStr,
					aSeparate:"^"
			 	},false);
			 
		    	if (parseInt(flg) <0) {
			    	this.checked=true;
					$.messager.alert("提示","取消关联感染诊断分类错误!",'info');
					return;
				}
			}
		});		
    }
    
	//显示全部
	$('#checkAll').click(function() {
		 obj.chkInfSub();
	});
   
    
	//诊断依据编辑
	obj.gridInfPosGist = $HUI.datagrid("#gridInfPosGist",{
		fit: true,
		//title: "感染诊断依据",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:false,
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.BTS.InfPosGistSrv",
			QueryName:"QryGistByInfPos",
			aInfPosID:''
	    },
		columns:[[
			{field:'TypeDesc',title:'诊断类型',width:100},
			{field:'Code',title:'代码',width:80},
			{field:'Desc',title:'诊断依据',width:700}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridInfPosGist_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridInfPosGist_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnGistAdd").linkbutton("enable");
			$("#btnGistEdit").linkbutton("disable");
			$("#btnGistDelete").linkbutton("disable");
		}
	});
		
		
	//诊断类型下拉框
	obj.cbokind = $HUI.combobox('#cboDiagType', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = 'DiagBasisType';
			param.aActive = '1';
			param.ResultSetType = 'array'
		}
	});
	InitInfPosWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}