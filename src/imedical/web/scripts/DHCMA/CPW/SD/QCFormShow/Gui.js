﻿//页面Gui
var objScreen = new Object();
var row = new Object();
editIndex=undefined;
function InitviewScreen(){
	var obj = objScreen;
	//前台获取病种+版本信息
	$m({
		ClassName:'DHCMA.CPW.SDS.QCMrListSrv',
		MethodName:'GetQCInfoByMrListID',
		aMrListID:MrListID	
	},function(data){
		obj.QCID=data.split('^')[0];
		obj.VerID=data.split('^')[1];
	})
	if (parseInt(Version)>0) obj.VerID=parseInt(Version)
    $.parser.parse(); // 解析整个页面
    ScoreArr=new Array(); //临时存储评分表内容 
	//表单编辑↓
	obj.endEditing=function (){
		if (editIndex == undefined){return true}	
		if ($('#gridQCFormShow').datagrid('validateRow', editIndex)){
			//列表中下拉框实现，修改后把回写textfied，因为显示的是textfied字段
			var ed = $('#gridQCFormShow').datagrid('getEditor', {index:editIndex,field:'ExecResult'});
			if (ed==null) {
					$('#gridQCFormShow').datagrid('endEdit', editIndex);
					editIndex = undefined;
					return true;
				} 
			if (ed.type=='combobox') {
				var ExecResultText = $(ed.target).combobox('getText');	
			}
			var rd=$('#gridQCFormShow').datagrid('getRows')[editIndex]
			$('#gridQCFormShow').datagrid('getRows')[editIndex]['ExecResultText'] = ExecResultText;	
			$('#gridQCFormShow').datagrid('endEdit', editIndex);
			///结束编辑时，校验出问题，显示原因
			var LinkCodeStr=$m({
				ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
				MethodName:"GetValiItemCode",
				aCode:rd.BTCode,
				aQCID:obj.QCID,
				aVerID:obj.VerID
			},false);
			var WarningInfo="",stopFlg=0
			if (LinkCodeStr!=""){
				var LinkCodeArr=LinkCodeStr.split(",")
				for (var t=0;t<LinkCodeArr.length;t++){
					var LinkCode=LinkCodeArr[t]
					var tIndex=$('#gridQCFormShow').datagrid('getRowIndex',LinkCode);
					var row=$('#gridQCFormShow').datagrid('getRows')[tIndex]
					var WarningInfo=obj.ValiItem(row)
					if (WarningInfo.indexOf('stop')>-1) {stopFlg=1}
					$("#gridQCFormShow").datagrid("updateRow",{  
            	       index:tIndex, //行索引  
                	   row:{  
                    		ExecWarning:WarningInfo
                    	  }  
     		 		})
				}
			}
			
			if (stopFlg==1) {return false}
			else{editIndex = undefined;return true;}
		} else {
			return false;
		}
	}	
	obj.gridQCEntityItem = $HUI.datagrid("#gridQCFormShow",{
		fit:true,
		title:title,
		iconCls:"icon-template",
		toolbar:'#custtb',
		headerCls:'panel-header-gray',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		rownumbers:true, 
		loadMsg:$g('数据加载中')+'...',
	    url:$URL,
	    nowrap:false,
	    bodyCls:'no-border',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCItemExecSrv",
			QueryName:"QryQCItemExec",
			  MrListID:MrListID,
			  aQCEntityID:obj.QCID,
			  aVerID:obj.VerID,	
		   	   rows:10000
	    },
		idField:'BTCode',
		columns:[[
			{field:'BTDesc',title:'描述',width:'420',sortable:true,align:'left',
				styler: function(value,row,index){
					return "text-align:left;background-color:#F6F6F6;border:1px solid #E3E3E3;"
				}
			},
			{field:'BTItemCatDesc',title:'项目分类',width:'150',hidden:true},
			{field:'ExecResult',title:'结果值',width:'350',sortable:false,
				styler: function(value,row,index){
					return "text-align:left;border:1px solid #E3E3E3"
				},
				formatter: function(value,row,index){
					if(value==""){
						return '<span style="color:#AEA6A8;">'+row.Resume+'</span>';
					}else {
						if (row.BTTypeDesc.indexOf('字典')>-1){
							return '<span style="color:#1474AF;">'+row.ExecResultText+'</span>';
						}else{
							return '<span style="color:#1474AF;">'+value+'</span>';
							}
					}
				}
			},
			{field:'ExecWarning',title:'提示信息',width:'230',
				formatter: function(value,row,index){
					if (((row.ExecResult=="")||(row.ExecResult=="def"))&&(row.BTIsNeeded=="是")){
						return '<span style="text-align:right;color:red;">'+$g('必填项不能为空')+'</span>';
					}else{
						valueArr=value.split('&')
						retValue=""
						for (var i=0;i<valueArr.length;i++){
							var xvalue=valueArr[i]
							var RuleType=xvalue.split('^')[1]
							var value=xvalue.split('^')[0]
							if (RuleType=='info') {
								retValue=retValue+'<span style="color:blue;">'+value+'</span><br>';
							}else if(RuleType=='warning'){
								retValue=retValue+'<span style="color:orange;">'+value+'</span><br>';
							}else if(RuleType=='stop'){
								retValue=retValue+'<span style="color:black;">'+value+'</span><br>';
							}
							else{
								retValue=retValue+'<span style="color:red;">'+value+'</span><br>';
							}
						}
						return retValue
					}
				}
			}
		]],
		groupField:'BTItemCat',
		view:groupview,
		groupFormatter:function(value, rows){
			return '<span style="font-size:16px">'+value+'</span>' ;
	        }, 
		rowStyler:function(index,row){  
	       if (row.EditPower==0){                //通过判断行的某个属性值 ，给row加载单独的样式
	           	return 'display:none';    
	       }else {
		       	return '';
		       }    
   		} ,
	    onClickRow:function(index,row){
		    obj.EditRow(index,row)
		    },
	    onBeforeEdit:function(index,row){  

	    },
	    onAfterEdit:function(index,row){
	        row.editing = false;
	        $('#gridQCFormShow').datagrid('refreshRow', index);
	    },
	    onCancelEdit:function(index,row){
	        row.editing = false;
	        $('#gridQCFormShow').datagrid('refreshRow', index);
	    }
	})
	
	obj.EditRow=function(index,row){
		if (row.EditPower==0) {
			$.messager.alert("错误提示", '前置条件不满足,不能填写该值');
			return false;
		}else {
			 $m({
					ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
					MethodName:"getItemTypeDescByCode",
					ItemCode:row.BTCode,
					aQCID:obj.QCID,
					aVerID:obj.VerID
				},function(EditType){
					$("#gridQCFormShow").datagrid('removeEditor','ExecResult');
					if (EditType.indexOf('字典')>-1) {
						var multi=false,rowStyle=""
						if (EditType.indexOf('多选')>-1)  {
							var multi=true
							var rowStyle='checkbox'
						}
						var ItemDicData=$cm({
								ClassName:'DHCMA.CPW.SDS.DictionarySrv',
								QueryName:'QryDictByType',
								ResultSetType:'Array',
								aTypeCode:row.BTCode,
								aQCID:obj.QCID,
								aVersion:obj.VerID,
								aIsActive:1	
							},false)
						var orgCount=ItemDicData.length
						var editFlg=false;
						if (orgCount>10) editFlg=true;
						$("#gridQCFormShow").datagrid('addEditor',[ //添加ExecResult列editor
				            {field:'ExecResult',editor:{
				                type:'combobox',
								options:{
									data:ItemDicData,
									valueField:'BTCode',
									textField:'BTDesc',
									multiple:multi,
									rowStyle:rowStyle, //显示成勾选行形式
									selectOnNavigation:false,
									defaultFilter:4,
									allowNull: true,
									editable:editFlg,
									onSelect:function(){
										var Value=$(this).combobox('getValues');
										Value=Value.join(',');
										obj.ChangeRowEditor(Value,row.BTCode)
									}
									,onAllSelectClick:function(e){
										var Value=$(this).combobox('getValues');
										Value=Value.join(',');
										obj.ChangeRowEditor(Value,row.BTCode)
									}
									,onUnselect:function(){
										var Value=$(this).combobox('getValues');
										Value=Value.join(',');
										obj.ChangeRowEditor(Value,row.BTCode)
									},onHidePanel:function(){
										//在处理相关项目显示隐藏前先校验所选值合法性
										obj.endEditing();	
									}
								}
				            }
				        }])
					}else if(EditType=="数值") {
						$("#gridQCFormShow").datagrid('addEditor',[ //添加BTCode列editor
				            {field:'ExecResult',editor:{
				                	type:'numberbox',
				                	options:{
					                	precision:2,
					                	onChange:function(){
											var Value=$(this).numberbox('getValue');
											obj.ChangeRowEditor(Value,row.BTCode)
										}
				                	}
				            	}
				            }
			        	])
					}else if(EditType=="整型") {
						$("#gridQCFormShow").datagrid('addEditor',[ //添加BTCode列editor
				            {field:'ExecResult',editor:{
				                	type:'numberbox',
				                	options:{
					                	min:0,
					                	precision:0,
					                	onChange:function(){
											var Value=$(this).numberbox('getValue');
											obj.ChangeRowEditor(Value,row.BTCode)
										}
				                	}
				            	}
				            }
			        	])
					}else if(EditType.indexOf("日期时间")>-1) {
						var ashowSeconds=false
						if (EditType.indexOf("秒")>-1) ashowSeconds=true;
						$("#gridQCFormShow").datagrid('addEditor',[ //添加BTCode列editor
				            {field:'ExecResult',editor:{
				                	type:'datetimebox',
				                	options:{
					                	editable:false,
					                	showSeconds:ashowSeconds,
					                	onChange:function(){
											var Value=$(this).datetimebox('getValue');
											obj.ChangeRowEditor(Value,row.BTCode)
										},onHidePanel:function(){
											//在处理相关项目显示隐藏前先校验所选值合法性
											debugger
											obj.endEditing();	
										}
				                	}
				            	}
				            }
			        	])
					}else if(EditType=="日期") {
						$("#gridQCFormShow").datagrid('addEditor',[ 
				            {field:'ExecResult',editor:{
				                	type:'datebox',
				                	options:{
					                	editable:false,
					                	onChange:function(){
											var Value=$(this).datetimebox('getValue');
											obj.ChangeRowEditor(Value,row.BTCode)
										},onHidePanel:function(){
											//在处理相关项目显示隐藏前先校验所选值合法性
											obj.endEditing();	
										}
				                	}
				            	}
				            }
			        	])
					}else if(EditType=="文本"){
						$("#gridQCFormShow").datagrid('addEditor',[ 
				            {field:'ExecResult',editor:{
					            	type:'text'
				            	}
				            }
			        	])
					}
					if (editIndex!=index) {
						if (obj.endEditing()){
							$('#gridQCFormShow').datagrid('selectRow', index).datagrid('beginEdit', index);
							editIndex = index;
					     	var ed = $('#gridQCFormShow').datagrid('getEditor', {index:editIndex,field:'ExecResult'});//获取当前编辑器
					     	var ItemID=row.BTID
					     	$m({ //获取表单评分项目Code
						     	ClassName:'DHCMA.CPW.SDS.QCEntityItemSrv',
						     	MethodName:'GetValItemByLinkID',
						     	aLinkID:ItemID
						     },function(valItemStr){
							       if (valItemStr=="") {
								     	//一般表单项目
								     	$(ed.target).focus();//获取焦点
								     	if ((EditType.indexOf("日期")>-1)||(EditType.indexOf("字典")>-1)) {
								     		$(ed.target).combobox('showPanel');
								     	}
								    }else{
								     	//评分表项目
								     	var valItemArr=valItemStr.split('^')
								     	var columns=3;
								     	var listHtml="<div id='ValHtml'>"
								     	for (var i=0;i<valItemArr.length;i++) {
									     	var DicType=valItemArr[i].split(',')[0]; //项目代码等同于字典类型
									     	var ItemCode=valItemArr[i].split(',')[0];
									     	var ItemDesc=valItemArr[i].split(',')[1];
									     	var strDicList =$m({
												ClassName:"DHCMA.CPW.SDS.DictionarySrv",
												MethodName:"GetDicsByTypeCode",
												aTypeCode:DicType,
												aMrListID:MrListID,
												aQCID:obj.QCID,
												aVerID:obj.VerID
											},false);
											if (strDicList=="") continue;
											var strDicList= Unhtml(strDicList,'<','&lt;')
											var strDicList= Unhtml(strDicList,'>','&gt;')	
											var dicList = strDicList.split(String.fromCharCode(1));
											var len =dicList.length;
											if (len<2)	continue;	//如果该评分字典小于2则返回:错误信息len为1，而有效字典不会少于2。
											var count = parseInt(len/columns)+1;
											var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
											listHtml+="<div style='clear:both'><h3 style='text-align:left;display:block;'>"+ItemDesc+"</h3>"
											listHtml+="<div>"
											var tmpGroup=""
											for (var index =0; index< count; index++) {
												var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
												var DicMaxLen=0
												for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
													var checked="";
													var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
													var dicGroup = dicSubList[3]
													var DicLabel=dicSubList[1]
													if (ScoreArr[editIndex]) {
														if ((ScoreArr[editIndex][ItemCode])&&(ScoreArr[editIndex][ItemCode].indexOf(dicSubList[4])>-1)) {
															checked="checked";
														}
													}else if (dicSubList[5]==1) checked="checked";
													//处理太长的描述折行显示后重叠的问题
													if (DicLabel.length>20) DicMaxLen=1
													if (dicGroup){
														listHtml += " <div style='overflow: auto;float:left;font-size:16px;width:"+per+"'><input id="+ItemCode+"-"+dicSubList[4]+" type='radio' name='"+editIndex+dicGroup+"' radiogroup='"+dicGroup+"' value="+dicSubList[2]+" "+checked+" class='hisui-radio' label='"+DicLabel+"'></div>";  
														var tmpGroup=dicGroup
													}else{
														listHtml += " <div style='overflow: auto;float:left;font-size:16px;width:"+per+"'><input id="+ItemCode+"-"+dicSubList[4]+" type='checkbox' name='"+editIndex+"' value="+dicSubList[2]+" "+checked+" class='hisui-checkbox' label='"+DicLabel+"'></div>";  
													}
												} 
												if (DicMaxLen==1) listHtml += '<div style="height:45px"></div>'
											}
											listHtml +="</div></div>"
								     	}
								     	listHtml +="</div>"
								     	$('#ValDic').append(listHtml)
								     	$HUI.dialog('#winVal').open();
								     	$.parser.parse('#ValDic');
								    }
							     })  
						}
					}else{
						obj.endEditing();
					}
				});
		}
		return true
	}
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

