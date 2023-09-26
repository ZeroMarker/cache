
var tabSelect =function(title,ind){
	if(ind==5){
		var jobj = $("#datatranspage");
		if (jobj.length>0&&jobj[0].src=="about:blank") jobj[0].src = "dhc.bdp.bdp.bdptranslation.csp";
	}
}
var CancelBtnClick=function(dataname,rowIndex){
	$(dataname).datagrid('cancelEdit',rowIndex);
}
var SaveBtnClick=function(dataname,rowIndex){
	var eidtors=$(dataname).datagrid('getEditors',rowIndex)
	if (eidtors.length>0){
		//为空不保存 EPR的为空也保存，掉后台实际是删除
		/*if((eidtors[0].target.val()=="")&&(dataname!="#tEPRTrans")){
			$(dataname).datagrid('cancelEdit',rowIndex);
			return;
		}*/
		$(dataname).datagrid('endEdit',rowIndex);
	}
}
var ToCompBtnClick=function(rowIndex,phrase,translation){
	if(editingFlags[0]){
		$.messager.alert('失败','请先保存正在编辑的行!');
		return;
	}
	$('#compdialog').dialog('open');
	
	$('#compdialog').dialog('setTitle',formatTitle(phrase,translation)+'组件');
	$('#tAffectedComp').datagrid('load',{Phrase:phrase,langid:langidGlobals[0]});
	$('#PhraseToComp').val(phrase);
	$('#TranslationToComp').val(translation);
}
var formatTitle=function(phrase,translation){
	var title='将【<span style="color:red;" title="'+phrase+'">'+replaceSpace(phrase.substring(0,15))+""+(phrase.length>15 ? "..." :"")+'</span>】的翻译【<span style="color:red;" title="'+translation+'">'+replaceSpace(translation.substring(0,15))+""+(translation.length>15 ? "..." :"")+'</span>】应用到&nbsp;&nbsp';
	return title;
}
//Phrase可能有空个，换成&nbsp;显示
function replaceSpace(str){
	var reg=new RegExp(" ","g");
	str = str.replace(reg,"&nbsp;");
	return str;
}
var ToMenuBtnClick=function(rowIndex,phrase,translation){
	if(editingFlags[0]){
		$.messager.alert('失败','请先保存正在编辑的行!');
		return;
	}
	$('#menudialog').dialog('open');
	$('#menudialog').dialog('setTitle',formatTitle(phrase,translation)+'菜单');
	$('#tAffectedMenu').datagrid('load',{Phrase:phrase,langid:langidGlobals[0]});
	$('#PhraseToMenu').val(phrase);
	$('#TranslationToMenu').val(translation);
}
var ToPageBtnClick=function(rowIndex,phrase,translation){
	if(editingFlags[0]){
		$.messager.alert('失败','请先保存正在编辑的行!');
		return;
	}
	$('#pagedialog').dialog('open');
	$('#pagedialog').dialog('setTitle',formatTitle(phrase,translation)+'页面');
	$('#tAffectedPage').datagrid('load',{Phrase:phrase,langid:langidGlobals[0]});
	$('#PhraseToPage').val(phrase);
	$('#TranslationToPage').val(translation);
}
var ToAllBtnClick=function(rowIndex,phrase,translation){
	if(editingFlags[0]){
		$.messager.alert('失败','请先保存正在编辑的行!');
		return;
	}
	var msg=formatTitle(phrase,translation)+"所有影响的组价、菜单、页面吗？";
	$.messager.confirm('提示信息' , msg , function(r){
		if(r){
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCTranslation",
				MethodName:"BuildAllByPhrase",
				Phrase:phrase,
				langid:langidGlobals[0]
				},
				function(data,textStatus){
					if(data>0){
						//alert(data);
						$.messager.alert('成功','应用成功!');
					}else{
						$.messager.alert('失败','应用失败!');
					}
				}
			);
		} else {
			return;
		}
	});

}

  
var editingFlags=[false,false,false,false,false];   //4个tab对应datagrid的编辑状态
var langidGlobals=["","","","",""];              //4个tab对应datagrid的语言
var tab2cmpid="";
var tab4cspname="";
var dheight=500;
var dsize=15;
//ID,Phrase,TransID,Translation
$(function(){
   
	var findTableHeight=parseInt($("#tt table").css('height'));
	dheight=parseInt($(window).height()-$("#tt table").eq(0).height()-35);
	dsize=parseInt((dheight-50)/27)-1;


	initTab1();
	initTab2();
	initTab3();
	initTab4();
	initTab5();

})



function initTab2(){
/*---------------------------
下面是组件翻译tab
------------------------------*/	
	var ComponentOnChange=function(){
		$('#compFindBtn').click();
	}
	$('#Component').combogrid({
		width:250,
		disabled:false,		
		delay: 500,
		panelWidth:250,
		mode: 'remote',
		queryParams:{ClassName:'websys.Component',QueryName: 'VBFindLE',name:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'ID',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{name:param.q});
			return true;
		},
		onSelect:ComponentOnChange,
		showHeader:false,
		columns: [[{field:'Name',title:'组件'},{field:'ID',title:'ID',align:'right',hidden:true,width:0}]]
	});
	
	$('#tComponentTrans').datagrid({
		queryParams: { cmpid : "",langid : session['LOGON.LANGID']  },
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCTranslation&QueryName=FindCompItems',
		idField:'ind' ,
		height:dheight,
		singleSelect:true,
		pageSize:15,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			{field:'ind',title:'ind',hidden:true},
			{field:'type',title:'类型',width:70,formatter:function(value,row,index){
				if (value=="I"){
					return "Item"
				}else if(value=="T"){
					return "TableItem"
				}else{
					return "Message"
				}
			}},
			{field:'name',title:'元素代码',width:180},
			{field:'caption',title:'元素描述',width:390,formatter:function(value){
				return replaceSpace(value);
			}},
			{field:'translation',title:'翻译',width:342,editor:{type:'text' ,options:{} } ,formatter:function(value){
				return replaceSpace(value);
			},styler: function(value, row, index){
				if(row.newFlag){
					return 'background-image:url(../images/default/grid/dirty.gif);background-repeat: no-repeat;';
				}
			}},
			{field:'Cancle',title:'撤销编辑',align:"center",width:80,formatter: function(value,row,index){
				var str='  <a href="#" onclick="CancelBtnClick(\'#tComponentTrans\','+index+')"><img src="../images/uiimages/undo.png"></a>  ';
				return str;
			}} ,
			{field:'Save',title:'保存',align:"center",width:40,formatter: function(value,row,index){
				var str='  <a href="#" onclick="SaveBtnClick(\'#tComponentTrans\','+index+')"><img src="../images/uiimages/update.png"></a>  ';
				return str;
			}} 
		]],
		onDblClickCell:function(rowIndex, field, value){
			if(field=="translation"){
				if(editingFlags[1]){
					$.messager.alert('失败','请先保存正在编辑的其它的行!');
					return;
				}
				$('#tComponentTrans').datagrid('beginEdit',rowIndex);
			}
		},
		onBeforeEdit:function (rowIndex, rowData){
			editingFlags[1]=true;
		},
		onCancelEdit:function (rowIndex, rowData){
			editingFlags[1]=false;
		},
		onAfterEdit:function (rowIndex, rowData, changes){
			editingFlags[1]=false;
			if((!(langidGlobals[1]>0))||(!(tab2cmpid>0))||(rowData.name=="")){ //||(rowData.translation=="")){
				
				return;
			}
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCTranslation",
				MethodName:"BulidOneByItemname",
				Type:"COMP",
				langid:langidGlobals[1],
				objid:tab2cmpid,
				itemname:rowData.name,
				translation:rowData.translation
				},
				function(data,textStatus){
					if(data>0){
						//alert(data);
						$.messager.alert('成功','保存成功!');
						rowData.newFlag=true;
						$('#tComponentTrans').datagrid('updateRow',{index:rowIndex,row:rowData});
					}else{
						$.messager.alert('失败','保存失败!');
					}
				}
			);
		},
		onLoadSuccess:function(){
			//datagrid加载成功后，将语言id放到langidGlobals[1]，以便保存；
			langidGlobals[1]=$('#tComponentTrans').datagrid('options').queryParams.langid;
			editingFlags[1]=false;
			tab2cmpid=$('#tComponentTrans').datagrid('options').queryParams.cmpid;
		}
		
	});
	
	$('#compLanguage').combobox('setValue',session['LOGON.LANGID']);
	
	$('#compFindBtn').click(function(){
		var langid=$('#compLanguage').combobox('getValue');
		if(!(langid>0)){
			langid=session['LOGON.LANGID'];
			$('#compLanguage').combobox('setValue',langid);
		}
		var cmpid=$('#Component').combogrid('getValue');
		$('#tComponentTrans').datagrid('load',{cmpid:cmpid,langid : langid});
		
	});	
}
function initTab3(){
/*---------------------------
下面是菜单翻译tab
------------------------------*/	
	$("#Menu").keydown(function(event) {    
		if (event.keyCode == 13) {    
			$('#menuFindBtn').click();
		}    
    });    
	$('#tMenuTrans').datagrid({
		queryParams: { desc : "",langid : session['LOGON.LANGID']  },
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCTranslation&QueryName=FindMenuByNameCapTrans',
		idField:'menuid' ,
		height:dheight,
		singleSelect:true,
		pageSize:15,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			{field:'menuid',title:'menuid',hidden:true},
			{field:'menuname',title:'菜单名',width:180},
			{field:'menucaption',title:'菜单描述',width:420},
			{field:'CurrentTranslation',title:'翻译',width:352,editor:{type:'text' ,options:{} } ,styler: function(value, row, index){
				if(row.newFlag){
					return 'background-image:url(../images/default/grid/dirty.gif);background-repeat: no-repeat;';
				}
			}},
			{field:'Cancle',title:'撤销编辑',align:"center",width:80,formatter: function(value,row,index){
				var str='  <a href="#" onclick="CancelBtnClick(\'#tMenuTrans\','+index+')"><img src="../images/uiimages/undo.png"></a>  ';
				return str;
			}} ,
			{field:'Save',title:'保存',align:"center",width:40,formatter: function(value,row,index){
				var str='  <a href="#" onclick="SaveBtnClick(\'#tMenuTrans\','+index+')"><img src="../images/uiimages/update.png"></a>  ';
				return str;
			}} 
		]],
		onDblClickCell:function(rowIndex, field, value){
			if(field=="CurrentTranslation"){
				if(editingFlags[2]){
					$.messager.alert('失败','请先保存正在编辑的其它的行!');
					return;
				}
				$('#tMenuTrans').datagrid('beginEdit',rowIndex);
			}
		},
		onBeforeEdit:function (rowIndex, rowData){
			editingFlags[2]=true;
		},
		onCancelEdit:function (rowIndex, rowData){
			editingFlags[2]=false;
		},
		onAfterEdit:function (rowIndex, rowData, changes){
			editingFlags[2]=false;
			if((!(langidGlobals[2]>0))||(!(rowData.menuid>0))||(rowData.menuname=="")){ //||(rowData.CurrentTranslation=="")){
				
				return;
			}
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCTranslation",
				MethodName:"BulidOneByItemname",
				Type:"MENU",
				langid:langidGlobals[2],
				objid:rowData.menuid,
				itemname:rowData.menuname,
				translation:rowData.CurrentTranslation
				},
				function(data,textStatus){
					if(data>0){
						//alert(data);
						$.messager.alert('成功','保存成功!');
						rowData.newFlag=true;
						$('#tMenuTrans').datagrid('updateRow',{index:rowIndex,row:rowData});
					}else{
						$.messager.alert('失败','保存失败!');
					}
				}
			);
		},
		onLoadSuccess:function(){
			//datagrid加载成功后，将语言id放到langidGlobals[1]，以便保存；
			langidGlobals[2]=$('#tMenuTrans').datagrid('options').queryParams.langid;
			editingFlags[2]=false;
		}
		
	});
	
	$('#menuLanguage').combobox('setValue',session['LOGON.LANGID']);
	
	$('#menuFindBtn').click(function(){
		var langid=$('#menuLanguage').combobox('getValue');
		if(!(langid>0)){
			langid=session['LOGON.LANGID'];
			$('#menuLanguage').combobox('setValue',langid);
		}
		var desc=$('#Menu').val();
		$('#tMenuTrans').datagrid('load',{desc:desc,langid : langid});
		
	});	
}
function initTab4(){
/*---------------------------
下面是页面翻译tab
------------------------------*/	
	var PageOnChange=function(){
		$('#pageFindBtn').click();
	}
	$('#Page').combogrid({     //查询csp应该与语言无关，但是只有^websys.TranslationD("PAGE",langid,cspname,itemname)这个Global，就暂时查session的语言吧
		width:300,
		disabled:false,		
		delay: 500,
		panelWidth:300,
		mode: 'remote',
		queryParams:{ClassName:'websys.DHCTranslation',QueryName: 'FindPagesByCspname',cspname:"",langid:session['LOGON.LANGID']},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'tcspname',
		textField: 'tcspname',
		onBeforeLoad:function(param){
			param = $.extend(param,{cspname:param.q});
			return true;
		},
		onSelect:PageOnChange,
		columns: [[{field:'tcspname',title:'页面',width:250}]]
	});

	$('#tPageTrans').datagrid({
		queryParams: { cspname : "",langid : session['LOGON.LANGID']  },
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCTranslation&QueryName=FindPageItems',
		idField:'ind' ,
		height:dheight,
		singleSelect:true,
		pageSize:15,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			{field:'ind',title:'ind',hidden:true},
			{field:'itemname',title:'元素名',width:300},
			{field:'translation',title:'翻译',width:300,editor:{type:'text' ,options:{} } ,styler: function(value, row, index){
				if(row.newFlag){
					return 'background-image:url(../images/default/grid/dirty.gif);background-repeat: no-repeat;';
				}
			}},
			{field:'Cancle',title:'撤销编辑',align:"center",width:80,formatter: function(value,row,index){
				var str='  <a href="#" onclick="CancelBtnClick(\'#tPageTrans\','+index+')"><img src="../images/uiimages/undo.png"></a>  ';
				return str;
			}} ,
			{field:'Save',title:'保存',align:"center",width:140,formatter: function(value,row,index){
				var str='  <a href="#" onclick="SaveBtnClick(\'#tPageTrans\','+index+')"><img src="../images/uiimages/update.png"></a>  ';
				return str;
			}} 
		]],
		onDblClickCell:function(rowIndex, field, value){
			if(field=="translation"){
				if(editingFlags[3]){
					$.messager.alert('失败','请先保存正在编辑的其它的行!');
					return;
				}
				$('#tPageTrans').datagrid('beginEdit',rowIndex);
			}
		},
		onBeforeEdit:function (rowIndex, rowData){
			editingFlags[3]=true;
		},
		onCancelEdit:function (rowIndex, rowData){
			editingFlags[3]=false;
		},
		onAfterEdit:function (rowIndex, rowData, changes){
			editingFlags[3]=false;
			if((!(langidGlobals[3]>0))||(tab4cspname=="")||(rowData.itemname=="")){ //||(rowData.translation=="")){
				
				return;
			}
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCTranslation",
				MethodName:"BulidOneByItemname",
				Type:"PAGE",
				langid:langidGlobals[3],
				objid:tab4cspname,
				itemname:rowData.itemname,
				translation:rowData.translation
				},
				function(data,textStatus){
					if(data>0){
						//alert(data);
						$.messager.alert('成功','保存成功!');
						rowData.newFlag=true;
						$('#tPageTrans').datagrid('updateRow',{index:rowIndex,row:rowData});
					}else{
						$.messager.alert('失败','保存失败!');
					}
				}
			);
		},
		onLoadSuccess:function(){
			//datagrid加载成功后，将语言id放到langidGlobals[1]，以便保存；
			langidGlobals[3]=$('#tPageTrans').datagrid('options').queryParams.langid;
			editingFlags[3]=false;
			tab4cspname=$('#tPageTrans').datagrid('options').queryParams.cspname;
		}
		
	});
	$('#pageLanguage').combobox('options').onSelect = function(row){
		PageOnChange();
		var p = $('#tPageTrans').datagrid('getPanel');
		p.find('.datagrid-view2 .datagrid-header tr.datagrid-header-row td[field="Save"] .datagrid-cell span').eq(0).html('保存成:'+row.text)
	};
	$('#pageLanguage').combobox('setValue',session['LOGON.LANGID']);
	
	$('#pageFindBtn').click(function(){
		var langid=$('#pageLanguage').combobox('getValue');
		if(!(langid>0)){
			langid=session['LOGON.LANGID'];
			$('#pageLanguage').combobox('setValue',langid);
		}
		var cspname=$('#Page').combogrid('getValue');
		$('#tPageTrans').datagrid('load',{cspname:cspname,langid : langid});
		
	});	
}
function initTab5(){
	var erpTypeData=[
		{ID:"0",classname:"全部",propertyname:"全部",desc:"全部"},
		{ID:"1",classname:"epr.Chart",propertyname:"Name",desc:"图表头"},
		{ID:"2",classname:"User.MRCObservationGroup",propertyname:"GRPDesc",desc:"User.MRCObservationGroup.GRPDesc"},
		{ID:"3",classname:"User.MRCObservationItem",propertyname:"ITMDesc",desc:"User.MRCObservationItem.ITMDesc"},
		{ID:"4",classname:"epr.CTChartItemType",propertyname:"PPDesc",desc:"epr.CTChartItemType.PPDesc"},
		{ID:"5",classname:"epr.CTPages",propertyname:"Description",desc:"epr.CTPages.Description"},
		{ID:"6",classname:"epr.CTProfileParams",propertyname:"PPDesc",desc:"epr.CTProfileParams.PPDesc"}
	];
	var EPRTypeOnChange=function(){
		$('#EPRFindBtn').click();
	}
	$("#EPRPhrase").keydown(function(event) {    
		if (event.keyCode == 13) {    
			$('#EPRFindBtn').click();
		}    
    }); 	
	$('#EPRType').combogrid({
		width:150,
		disabled:false,	
		panelWidth:400,
		data:erpTypeData,
		idField: 'ID',
		textField: 'desc',
		onSelect:EPRTypeOnChange,
		editable:false,
		columns: [[{field:'classname',title:'类',width:200},{field:'propertyname',title:'属性',width:90},{field:'desc',title:'说明',width:90},{field:'ID',title:'ID',hidden:true}]]
	}).combogrid('setValue',0);	
	$('#tEPRTrans').datagrid({
		queryParams: { langid : session['LOGON.LANGID'], phrase : "", untranslated : "",qclassname:"",qpropertyname:""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCTranslation&QueryName=FindEprItems',
		idField:'ID' ,
		height:dheight,
		singleSelect:true,
		pageSize:15,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			//{ field: 'ck', checkbox: true },
			{field:'ID',title:'TransERP表ID',hidden:true} ,
			{field:'classname',title:'类',width:210} ,
			{field:'propertyname',title:'属性',width:100} ,
			{field:'Phrase',title:'短语',width:380,formatter:function(value){
				return replaceSpace(value);
			}} ,
			{field:'Translation',title:'翻译',width:285,editor:{type:'text' ,options:{} } ,formatter:function(value){
				return replaceSpace(value);
			},styler: function(value, row, index){
				if(row.newFlag){
					return 'background-image:url(../images/default/grid/dirty.gif);background-repeat: no-repeat;';
				}
			}} ,
			//{field:'inuse',title:'在用',align:"center",width:50,formatter: function(value,row,index){
			//	if(value=="1"){
			//		return "Y";
			//	}else{
			//		return "";
			//	}
			//}} ,
			{field:'Cancle',title:'撤销编辑',align:"center",width:80,formatter: function(value,row,index){
				var str='  <a href="#" onclick="CancelBtnClick(\'#tEPRTrans\','+index+')"><img src="../images/uiimages/undo.png"></a>  ';
				return str;
			}} ,
			{field:'Save',title:'保存',align:"center",width:40,formatter: function(value,row,index){
				var str='  <a href="#" onclick="SaveBtnClick(\'#tEPRTrans\','+index+')"><img src="../images/uiimages/update.png"></a>  ';
				return str;
			}} 			

		]],
		onDblClickRow: function (rowIndex, rowData) {  
			//alert("onDblClickRow");
		},
		onDblClickCell:function(rowIndex, field, value){
			if(field=="Translation"){
				if(editingFlags[4]){
					$.messager.alert('失败','请先保存正在编辑的其它的行!');
					return;
				}
				$('#tEPRTrans').datagrid('beginEdit',rowIndex);
			}
		},
		onBeforeEdit:function (rowIndex, rowData){
			editingFlags[4]=true;
		},
		onCancelEdit:function (rowIndex, rowData){
			editingFlags[4]=false;
		},
		onAfterEdit:function (rowIndex, rowData, changes){
			editingFlags[4]=false;
			//alert("保存。。。掉后台。。。成功,"+rowIndex+","+rowData.TransID+","+rowData.Translation);
			if((!(langidGlobals[4]>0))||(!(rowData.ID>0))){     // ||($.trim(rowData.Translation)=="")
				//alert(langidGlobals[0]+","+rowData.ID+","+$.trim(rowData.Translation)+","+rowData.Translation+",End");
				//alert(changes.Translation);
				return;
			}
			//console.log(rowData);
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCTranslation",
				MethodName:"SaveEprTrans",
				langid:langidGlobals[4],
				rowid:rowData.ID,
				trans:rowData.Translation
				},
				function(data,textStatus){
					if(data>0){
						//alert(data);
						$.messager.alert('成功','保存成功!');
						rowData.newFlag=true;
						$('#tEPRTrans').datagrid('updateRow',{index:rowIndex,row:rowData});
					}else{
						$.messager.alert('失败','保存失败!');
					}
				}
			);
		},
		onLoadSuccess:function(){
			//datagrid加载成功后，将语言id放到langidGlobals[0]，以便保存；
			langidGlobals[4]=$('#tEPRTrans').datagrid('options').queryParams.langid;
			editingFlags[4]=false;
		}
	});
	$('#EPRLanguage').combobox('setValue',session['LOGON.LANGID']);
	$('#EPRFindBtn').click(function(){
		var classname="",propertyname="";
		var eprtypeid=$('#EPRType').combogrid('getValue');
		if (eprtypeid>0){
			classname=erpTypeData[eprtypeid].classname;
			propertyname=erpTypeData[eprtypeid].propertyname;
		}


		var langid=$('#EPRLanguage').combobox('getValue');
		if(!(langid>0)){
			langid=session['LOGON.LANGID'];
			$('#EPRLanguage').combobox('setValue',langid);
		}
		var phrase=$('#EPRPhrase').val();
		var onlyUnTranslated="";
		if($('#EPROnlyUnTranslated').attr('checked')){
			onlyUnTranslated="on";
		}
		$('#tEPRTrans').datagrid('load',{langid : langid, phrase : phrase, untranslated : onlyUnTranslated,qclassname:classname,qpropertyname:propertyname});
		
	});	
	$('#EPRBuildAll').click(function(){
		if(editingFlags[4]){
			$.messager.alert('失败','请先保存正在编辑的行!');
			return;
		}
		var msg="确定从EPR设置出刷新列表?";
		$.messager.confirm('提示信息' , msg , function(r){
			if(r){
				$.messager.progress({ 
					title:'请稍后', 
					msg:'正在重新构建，请稍后...',
					text:'Appling'
				});
				$.ajaxRunServerMethod({
					ClassName:"websys.TranslationEPR",
					MethodName:"Build"
					},
					function(data,textStatus){
						$.messager.progress('close');
						$.messager.alert('成功','完成!');
						$('#EPRFindBtn').click();
					}
				);
			} else {
				return;
			}
		});
	});	
}
function initTab1(){
	$("#Phrase").keydown(function(event) {    
		if (event.keyCode == 13) {    
			$('#FindBtn').click();
		}    
    }); 	
	$('#tDictionaryTranslated').datagrid({
		queryParams: { langidX : session['LOGON.LANGID'], phrase : "", untranslated : ""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DictionaryTranslated&QueryName=Find',
		idField:'ID' ,
		height:dheight,
		singleSelect:true,
		pageSize:15,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			//{ field: 'ck', checkbox: true },
			{field:'ID',title:'字典表ID',hidden:true} ,
			{field:'Phrase',title:'短语',width:380,formatter:function(value){
				return replaceSpace(value);
			}} ,
			{field:'TransID',title:'翻译表ID',hidden:true} ,
			{field:'Translation',title:'翻译',width:285,editor:{type:'text' ,options:{} } ,formatter:function(value){
				return replaceSpace(value);
			},styler: function(value, row, index){
				if(row.newFlag){
					return 'background-image:url(../images/default/grid/dirty.gif);background-repeat: no-repeat;';
				}
			}} ,
			{field:'Cancle',title:'撤销编辑',align:"center",formatter: function(value,row,index){
				var str='  <a href="#" onclick="CancelBtnClick(\'#tDictionaryTranslated\','+index+')"><img src="../images/uiimages/undo.png"></a>  ';
				return str;
			}} ,
			{field:'Save',title:'保存',align:"center",formatter: function(value,row,index){
				var str='  <a href="#" onclick="SaveBtnClick(\'#tDictionaryTranslated\','+index+')"><img src="../images/uiimages/update.png"></a>  ';
				return str;
			}} ,
			{field:'ToComp',title:'应用到组件',align:"center",formatter: function(value,row,index){
				var str='  <a class="apply" href="#" onclick="ToCompBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')">组件</a>  ';
				return str;
			}} ,
			{field:'ToMenu',title:'应用到菜单',align:"center",formatter: function(value,row,index){
				var str='  <a class="apply" href="#" onclick="ToMenuBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')">菜单</a>  ';
				return str;
			}} ,
			{field:'ToPage',title:'应用到页面',align:"center",formatter: function(value,row,index){
				var str='  <a class="apply" href="#" onclick="ToPageBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')">页面</a>  ';
				return str;
			}} ,
			{field:'ToAll',title:'应用到所有',align:"center",formatter: function(value,row,index){
				var str='  <a class="apply" href="#" onclick="ToAllBtnClick('+index+',\''+row.Phrase+'\''+',\''+row.Translation+'\')">所有</a>  ';
				return str;
			}} 
		]],
		onDblClickRow: function (rowIndex, rowData) {  
			//alert("onDblClickRow");
		},
		onDblClickCell:function(rowIndex, field, value){
			if(field=="Translation"){
				if(editingFlags[0]){
					$.messager.alert('失败','请先保存正在编辑的其它的行!');
					return;
				}
				$('#tDictionaryTranslated').datagrid('beginEdit',rowIndex);
			}
		},
		onBeforeEdit:function (rowIndex, rowData){
			editingFlags[0]=true;
		},
		onCancelEdit:function (rowIndex, rowData){
			editingFlags[0]=false;
		},
		onAfterEdit:function (rowIndex, rowData, changes){
			editingFlags[0]=false;
			//alert("保存。。。掉后台。。。成功,"+rowIndex+","+rowData.TransID+","+rowData.Translation);
			if((!(langidGlobals[0]>0))||(!(rowData.ID>0))){ //||($.trim(rowData.Translation)=="")){
				//alert(langidGlobals[0]+","+rowData.ID+","+$.trim(rowData.Translation)+","+rowData.Translation+",End");
				//alert(changes.Translation);
				return;
			}
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCTranslation",
				MethodName:"AddTranslationItem",
				langid:langidGlobals[0],
				phraseid:rowData.ID,
				trans:rowData.Translation,
				transid:rowData.TransID
				},
				function(data,textStatus){
					if(data>0){
						//alert(data);
						$.messager.alert('成功','保存成功!');
						rowData.TransID=data;
						rowData.newFlag=true;
						$('#tDictionaryTranslated').datagrid('updateRow',{index:rowIndex,row:rowData});
					}else{
						$.messager.alert('失败','保存失败!');
					}
				}
			);
		},
		onLoadSuccess:function(){
			//datagrid加载成功后，将语言id放到langidGlobals[0]，以便保存；
			langidGlobals[0]=$('#tDictionaryTranslated').datagrid('options').queryParams.langidX;
			editingFlags[0]=false;
		}
	});

	$('#FindBtn').click(function(){
		var langid=$('#Language').combobox('getValue');
		if(!(langid>0)){
			langid=session['LOGON.LANGID'];
			$('#Language').combobox('setValue',langid);
		}
		var phrase=$('#Phrase').val();
		var onlyUnTranslated="";
		if($('#OnlyUnTranslated').attr('checked')){
			onlyUnTranslated="on";
		}
		$('#tDictionaryTranslated').datagrid('load',{langidX : langid, phrase : phrase, untranslated : onlyUnTranslated});
		
	});
	$('#BuildAll').click(function(){
		if(editingFlags[0]){
			$.messager.alert('失败','请先保存正在编辑的行!');
			return;
		}
		var msg="确定根据翻译表重建所有组件、菜单、页面翻译么";
		$.messager.confirm('提示信息' , msg , function(r){
			if(r){
				$.messager.progress({ 
					title:'请稍后', 
					msg:'正在重新构建，请稍后...',
					text:'Appling'
				});
				$.ajaxRunServerMethod({
					ClassName:"websys.DHCTranslation",
					MethodName:"BuildAll",
					langid:langidGlobals[0]
					},
					function(data,textStatus){
						$.messager.progress('close');
						if(data>0){
							//alert(data);
							$.messager.alert('成功','重建成功!');
						}else{
							$.messager.alert('失败','重建失败!');
						}
					}
				);
			} else {
				return;
			}
		});
	});
	$('#Language').combobox('setValue',session['LOGON.LANGID']);
	
	
	//受影响的组件
	$('#tAffectedComp').datagrid({
		queryParams: { Phrase : "",langid:""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCTranslation&QueryName=FindAffectedComp',
		idField:'cmpid' ,
		height:415,
		singleSelect:false,
		pageSize:12,
		rownumbers: true,
		pagination: true,
		pageList: [12],  
		striped: true ,	
		toolbar: ["-", {
					id: '',
					text: '应用',
					iconCls: 'icon-apply',
					handler: function(){
								var rows=$('#tAffectedComp').datagrid('getSelections');
								if (rows.length<=0){
									$.messager.alert('失败','至少选择一条数据!');
									return false;
								}
								var cmpids=[];
								for (var i=0;i<rows.length;i++) {
									cmpids.push(rows[i].cmpid);
								}
								var cmpidsStr=cmpids.join("^");
								//alert(cmpidsStr);
								var phrase=$('#PhraseToComp').val();
								var translation=$('#TranslationToComp').val();
								var msg=formatTitle(phrase,translation)+"您选中组件吗？";
								$.messager.confirm('提示信息' , msg , function(r){
									if(r){
										$.ajaxRunServerMethod({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildComponentsByPhrase",
											cmpids:cmpidsStr,
											Phrase:phrase,
											langid:langidGlobals[0]
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('成功','应用成功!');
												}else{
													$.messager.alert('失败','应用失败!');
												}
												$('#tAffectedComp').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});								
							}
				},"-",{
					id: '',
					text: '应用全部',
					iconCls: 'icon-apply',
					handler: function(){
								var phrase=$('#PhraseToComp').val();
								var translation=$('#TranslationToComp').val();
								var msg=formatTitle(phrase,translation)+"所有影响的组件吗？";
								$.messager.confirm('提示信息' , msg , function(r){
									if(r){
										$.ajaxRunServerMethod({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildAllComponentsByPhrase",
											Phrase:phrase,
											langid:langidGlobals[0]
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('成功','应用成功!');
												}else{
													$.messager.alert('失败','应用失败!');
												}
												$('#tAffectedComp').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});

							}

				},"-"],		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'cmpid',title:'组件id',hidden:true},
			{field:'cmpname',title:'组件名'} ,
			{field:'CurrentTranslation',title:'当前组件翻译',formatter:function(value){
				return replaceSpace(value);
			}} 
		]]
	});

		//受影响的菜单
	$('#tAffectedMenu').datagrid({
		queryParams: { Phrase : "",langid:""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCTranslation&QueryName=FindAffectedMenu',
		idField:'menuid' ,
		height:415,
		singleSelect:false,
		pageSize:12,
		rownumbers: true,
		pagination: true,
		pageList: [12],  
		striped: true ,	
		toolbar: ["-", {
					id: '',
					text: '应用',
					iconCls: 'icon-apply',
					handler: function(){
								var rows=$('#tAffectedMenu').datagrid('getSelections');
								if (rows.length<=0){
									$.messager.alert('失败','至少选择一条数据!');
									return false;
								}
								var menuids=[];
								for (var i=0;i<rows.length;i++) {
									menuids.push(rows[i].menuid);
								}
								var menuidsStr=menuids.join("^");
								//alert(menuidsStr);
								var phrase=$('#PhraseToMenu').val();
								var translation=$('#TranslationToMenu').val();
								var msg=formatTitle(phrase,translation)+"您选中的菜单吗？";
								$.messager.confirm('提示信息' , msg , function(r){
									if(r){
										$.ajaxRunServerMethod({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildMenusByPhrase",
											menuids:menuidsStr,
											Phrase:phrase,
											langid:langidGlobals[0]
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('成功','应用成功!');
												}else{
													$.messager.alert('失败','应用失败!');
												}
												$('#tAffectedMenu').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});

							}
				},"-",{
					id: 'icon-apply',
					text: '应用全部',
					iconCls: '',
					handler: function(){
								var phrase=$('#PhraseToMenu').val();
								var translation=$('#TranslationToMenu').val();
								var msg=formatTitle(phrase,translation)+"所有影响的菜单吗？";
								$.messager.confirm('提示信息' , msg , function(r){
									if(r){
										$.ajaxRunServerMethod({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildAllMenusByPhrase",
											Phrase:phrase,
											langid:langidGlobals[0]
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('成功','应用成功!');
												}else{
													$.messager.alert('失败','应用失败!');
												}
												$('#tAffectedMenu').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});								

							}

				},"-"],		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'menuid',title:'菜单id',hidden:true},
			{field:'menuname',title:'菜单名'} ,
			{field:'CurrentTranslation',title:'当前菜单翻译'}
		]]
	});
	
	//受影响的页面
	$('#tAffectedPage').datagrid({
		queryParams: { Phrase : "",langid:""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCTranslation&QueryName=FindAffectedPage',
		idField:'ind' ,
		height:415,
		singleSelect:false,
		pageSize:12,
		rownumbers: true,
		pagination: true,
		pageList: [12],  
		striped: true ,	
		toolbar: ["-", {
					id: '',
					text: '应用',
					iconCls: 'icon-apply',
					handler: function(){
								var rows=$('#tAffectedPage').datagrid('getSelections');
								console.log(rows);
								if (rows.length<=0){
									$.messager.alert('失败','至少选择一条数据!');
									return false;
								}
								var cspnames=[];
								for (var i=0;i<rows.length;i++) {
									cspnames.push(rows[i].cspname);
								}
								var cspnamesStr=cspnames.join("^");
								//alert(cspnamesStr);
								var phrase=$('#PhraseToPage').val();
								var translation=$('#TranslationToPage').val();
								var msg=formatTitle(phrase,translation)+"您选择的页面吗？";
								$.messager.confirm('提示信息' , msg , function(r){
									if(r){
										$.ajaxRunServerMethod({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildPagesByPhrase",
											cspnames:cspnamesStr,
											Phrase:phrase,
											langid:langidGlobals[0]
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('成功','应用成功!');
												}else{
													$.messager.alert('失败','应用失败!');
												}
												$('#tAffectedPage').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});									

							}
				},"-",{
					id: '',
					text: '应用全部',
					iconCls: 'icon-apply',
					handler: function(){
								var phrase=$('#PhraseToPage').val();
								var translation=$('#TranslationToPage').val();
								var msg=formatTitle(phrase,translation)+"所有影响的页面吗？";
								$.messager.confirm('提示信息' , msg , function(r){
									if(r){
										$.ajaxRunServerMethod({
											ClassName:"websys.DHCTranslation",
											MethodName:"BuildAllPagesByPhrase",
											Phrase:phrase,
											langid:langidGlobals[0]
											},
											function(data,textStatus){
												if(data>0){
													//alert(data);
													$.messager.alert('成功','应用成功!');
												}else{
													$.messager.alert('失败','应用失败!');
												}
												$('#tAffectedPage').datagrid('unselectAll');
											}
										);
									} else {
										return;
									}
								});	

							}

				},"-"],		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'ind',title:'计数器',hidden:true},
			{field:'cspname',title:'页面名'} ,
			{field:'CurrentTranslation',title:'当前页面翻译'}
		]]
	});

	$('#compdialog').dialog({
		onClose:function(){
			$('#tAffectedComp').datagrid('unselectAll');
		}
	});
	$('#menudialog').dialog({
		onClose:function(){
			$('#tAffectedMenu').datagrid('unselectAll');
		}
	});
	$('#pagedialog').dialog({
		onClose:function(){
			$('#tAffectedPage').datagrid('unselectAll');
		}
	});	
}