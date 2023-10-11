$(function(){
    InitFavDataList();
    InitFavType();
});
function InitFavType()
{
    $.cm({
		ClassName:'DHCDoc.Diagnos.Fav',
		MethodName:'GetFavTypeJSON',
		CONTEXT:ServerObj.CONTEXT, 
		LocID:session['LOGON.CTLOCID'],
		UserID:session['LOGON.USERID']
	},function(FavTypeData){
		$("#kwFavType").keywords({
			singleSelect:true,
			labelCls:'red',
			items:FavTypeData,
			onClick:function(){
				InitFavCatBar();
			}
		});
		InitFavCatBar();
	});
}
function GetCatType()
{
	return "User."+$("#kwFavType").keywords('getSelected')[0].id;
}
function InitFavCatBar()
{
	$('#FavCatBar').marybtnbar({
		url:'websys.Broker.cls',
		selectMode:true,
		onBeforeLoad:function(param){
			$('#tabFav').datagrid('loadData',[]);
			$.extend(param,{
				ClassName:'DHCDoc.Diagnos.Fav',
				MethodName:'GetFavData',
				Type:GetCatType(),
				CONTEXT:ServerObj.XCONTEXT, 
				LocID:session['LOGON.CTLOCID'],
				UserID:session['LOGON.USERID'],
				EpisodeID:ServerObj.EpisodeID
			});
		},
		onSelect:function(jq,cfg){
			if(!cfg){
				$('#tabFav').datagrid('loadData',[]);
				return false;
			}
			var data=new Array();
			var children=cfg.children||[];
			for(var i=0;i<children.length;i++){
				var row=children[i];
				data.push($.extend({},row.attributes,{id:row.id,text:row.text,children:row.children}));
			}
			$('#tabFav').datagrid('loadData',data);
		},
		onLoadSuccess:function(data){
			if(data.length){
				$(this).marybtnbar('select',$(this).find('a').eq(0));
			}
		}
	});
}
function InitFavDataList()
{
	var NoteWidth=110;
	var Width=$("#FavCatBar").width();
	if (Width>330) NoteWidth=150
	$('#tabFav').datagrid({
		url:'',
		striped:true,
		fit:true,
		fitColumns:true,
		singleSelect:true,
		rownumbers:true,
		pagination:false,
		border:false,
        columns:[[ 
            {field:'id',hidden:true},
            {field:'ICDRowid',hidden:true},
			{field:'SDSInfo',hidden:true},
			{field:'Type',title:$g('类型'),width:50,
				formatter: function(value,row,index){
					switch (parseInt(value)) {
						case 2:return $g('证型');
						case 1:return $g('中医');
						default:return $g('西医');
					}
				}
			},
			{field:'Prefix',title:'前缀',width:50,hidden:ServerObj.SDSDiagEntry}, 
			{field:'ICDDesc',title:'ICD诊断',width:NoteWidth},
			{field:'Note',title:'诊断备注',width:80}
		]],
		onDblClickRow:function(index, row){
			var CMFlag='';
			if(row.Type=='1') CMFlag='Y';
			else if(row.Type=='2') CMFlag='H';
			parent.AddDiagItemtoList(row.ICDRowid,row.Note,CMFlag,row.Prefix,row.SDSInfo);
			if(row.children&&row.children.length){
				//setTimeout(function(){parent.$('input:focus').blur();});
				parent.$('input[name="DiagnosICDDesc"').lookup('disable');
				OpenSyndromeDialog(row);
			}else{
				if (parent.ServerObj.DiagFromTempOrHisAutoSave==1){
					parent.InsertMutiMRDiagnos();
				}
			}
		},
		onLoadSuccess:function(data){
			$(this).prev().find('.datagrid-body').find('div.datagrid-cell').overflowtip();
		}
	});
}
function ReloadFavDataList()
{
	var data=$('#tabFav').datagrid('getData');
	InitFavDataList();
	$('#tabFav').datagrid('loadData',data);
}
function OpenSyndromeDialog(row)
{
	if(!parent.$('#_Syndrome_Dialog').size()){
		parent.$('body').append('<div id="_Syndrome_Dialog"></div>');
		parent.$('#_Syndrome_Dialog').dialog({  
			width: 600,    
			height: 400,    
			content:'<table id="_Syndrome_List"></table>',  
			modal: true,
			buttons:[{
				text:$g('添加选中证型'),
				iconCls: 'icon-w-ok',
				handler:function(){
					var rows=parent.$('#_Syndrome_List').datagrid('getChecked');
					if(!rows.length){
						parent.$.messager.popover({msg:"请选择需要添加的证型",type:'alert'});
						return;
					}
					for(var i=0;i<rows.length;i++){
                        var row=rows[i];
                        var index=parent.$('#_Syndrome_List').datagrid('getRowIndex',rows[i]);
                        var Editors=parent.$('#_Syndrome_List').datagrid('getEditors',index);
						if(Editors.length){
                            row.SyndromeID=parent.$(Editors[0].target).lookup('getValue');
                            var SyndDesc=parent.$(Editors[0].target).val();
                            if(SyndDesc=='')  row.SyndromeID='';
                            row.Note=parent.$(Editors[1].target).val();
                        }
                        if(!row.SyndromeID&&!row.Note) continue;
						parent.AddDiagItemtoList(row.SyndromeID,row.Note,"H");
					}
					parent.$('#_Syndrome_Dialog').dialog('close');
				}
			}] ,
			onClose:function(){
				parent.$('input[name="DiagnosICDDesc"').lookup('enable');
				if (parent.ServerObj.DiagFromTempOrHisAutoSave==1){
					parent.InsertMutiMRDiagnos();
				}
			} 
		}).dialog('open'); 
		parent.$('#_Syndrome_List').datagrid({
			url:'DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Grid',
			striped:true,
			fit:true,
			fitColumns:true,
			singleSelect:false,
			rownumbers:true,
			pagination:false,
			border:false,
			toolbar:[{
				text:'增加',
				iconCls: 'icon-add',
				handler: function(){
					var selected=$('#tabFav').datagrid('getSelected');
					if(!selected){
						parent.$.messager.popover({msg:"先选择模板项目",type:'alert'});
						return false;
					}
					parent.$('#_Syndrome_List').datagrid('appendRow',{});
					var rows= parent.$('#_Syndrome_List').datagrid('getRows');
					parent.$('#_Syndrome_List').datagrid('beginEdit',rows.length-1);
				}
			},'-',{
				text:'删除',
				iconCls: 'icon-remove',
				handler: function(){
					var SelArr= parent.$('#_Syndrome_List').datagrid('getSelections');
					if(!SelArr.length){
						parent.$.messager.popover({msg:"请选择需要删除的数据",type:'alert'});
						return;
					}
					for(var i=SelArr.length-1;i>=0;i--){
						if(!SelArr[i].ID){
							var index=parent.$('#_Syndrome_List').datagrid('getRowIndex',SelArr[i]);
							parent.$('#_Syndrome_List').datagrid('deleteRow',index);
							SelArr.splice(i,1);
						}
					}
					if(SelArr.length){
						parent.$.messager.confirm('提示','确定删除选中数据?',function(r){
							if(r){
								$.each(SelArr,function(){
									var ret=$.cm({
										ClassName:'DHCDoc.Diagnos.Fav',
										MethodName:'DeleteSyndrome',
										ID:this.ID,
										dataType:'text'
									},false);
								});
								parent.$.messager.popover({msg:"删除成功",type:'success'});
								parent.$('#_Syndrome_List').datagrid('reload');
							}
						});
					}
				}
			},'-',{
				text:'保存',
				iconCls: 'icon-save',
				handler: function(){
					var selected=$('#tabFav').datagrid('getSelected');
					if(!selected) return false;
					var ItemID=selected.id.split('_')[1];
					var SaveRows=new Array();
					var rows= parent.$('#_Syndrome_List').datagrid('getRows');
					for(var i=0;i<rows.length;i++){
						var Editors=parent.$('#_Syndrome_List').datagrid('getEditors',i);
						if(!Editors.length) continue;
						var row=rows[i];
						if(!row.ID) row.ID="";
						row.SyndromeID=parent.$(Editors[0].target).lookup('getValue');
						var SyndDesc=parent.$(Editors[0].target).val();
						if(SyndDesc=='')  row.SyndromeID='';
						row.Note=parent.$(Editors[1].target).val();
						if(!row.SyndromeID&&!row.Note) continue;
						SaveRows.push(row);
					}
					if(!SaveRows.length){
						parent.$.messager.popover({msg:'没有需要保存的数据',type:'alert'});
						return
					}
					var ret=$.cm({
						ClassName:'DHCDoc.Diagnos.Fav',
						MethodName:'SaveSyndromes',
						ItemID:ItemID,
						UserID:session['LOGON.USERID'],
						SaveRows:JSON.stringify(SaveRows),
						dataType:'text'
					},false);
					if(ret=='0'){
						parent.$.messager.popover({msg:'保存成功',type:'success'});
						parent.$('#_Syndrome_List').datagrid('reload');
					}else{
						parent.$.messager.alert('提示','保存失败:'+ret,'warning');
					}
				}
			},'-',{
				text:'上移',
				iconCls: 'icon-arrow-top',
				handler: function(){
					MoveDataGridRow(parent.$('#_Syndrome_List'),'UP','UpdatSyndromeSeq');
				}
			},'-',{
				text:'下移',
				iconCls: 'icon-arrow-bottom',
				handler: function(){
					MoveDataGridRow(parent.$('#_Syndrome_List'),'DOWN','UpdatSyndromeSeq');
				}
			}],
			columns:[[ 
				{field:'Check',checkbox:true},
				{field:'ID',hidden:true},  
                {field:'SyndromeID',hidden:true},   
                {field:'SyndDesc',title:'证型名称',width:120,editor:{
                        type:'lookup',
                        options:{
                            url:$URL,
                            mode:'remote',
                            method:"Get",
                            idField:'HIDDEN',
                            textField:'desc',
                            columns:[[  
                                {field:'desc',title:'诊断名称',width:300,sortable:true},
                                {field:'code',title:'code',width:120,sortable:true},
                                {field:'HIDDEN',hidden:true}
                            ]],
                            pagination:true,
                            panelWidth:500,
                            panelHeight:410,
                            isCombo:true,
                            minQueryLen:2,
                            delay:'500',
                            queryOnSameQueryString:true,
                            queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
                            onBeforeLoad:function(param){
                                var desc=param['q'];
                                param = $.extend(param,{desc:desc,ICDType:2});
                            }
                        }
                    }
                },   
                {field:'Note',title:'备注',width:100,editor:{type:'text'}}
			]],
			onDblClickRow:function(index, row){
				if(!row.SyndromeID&&!row.Note) return;
				parent.AddDiagItemtoList(row.SyndromeID,row.Note,"H");
				parent.$('#_Syndrome_Dialog').dialog('close');
			},
            onBeforeLoad:function(param){
                var selected=$('#tabFav').datagrid('getSelected');
                if(!selected) return false;
                parent.$('#_Syndrome_List').datagrid('uncheckAll');
                param.ClassName='DHCDoc.Diagnos.Fav';
                param.QueryName='QuerySyndromeNew';
                param.ItemID=selected.id.split('_')[1]; 
                DisableToolbar(parent.$('#_Syndrome_List'),!ServerObj.FavAuth[GetCatType()])
            }
		});
	}else{
        parent.$('#_Syndrome_List').datagrid('reload');
    }
	parent.$('#_Syndrome_Dialog').dialog('setTitle',row.text+$g(' 证型选择')).dialog('open');
}
function MoveDataGridRow($dg,arrow,MethodName)
{
    var curRow=$dg.datagrid('getSelected');
    if(!curRow){
        parent.$.messager.popover({msg:'请选择需要移动的行!',type:'alert'});
        return;
    }
    var index=$dg.datagrid('getRowIndex',curRow);
    var rows=$dg.datagrid('getRows');
    for(var i=0;i<rows.length;i++){
        var Editors=$dg.datagrid('getEditors',i);
        if(Editors.length){
	        parent.$.messager.popover({msg:'请先完成正在编辑的行!',type:'alert'});
            return;
        }
    }
    var changeIndex=-1;
    if(arrow=='UP'){
        if(index==0){
            parent.$.messager.popover({msg:'已是第一行!',type:'alert'});
            return false;
        }
        changeIndex=index-1;
    }else{
        if(index==(rows.length-1)){
            parent.$.messager.popover({msg:'已是最后一行!',type:'alert'});
            return false;
        }
        changeIndex=index+1;
    }
    rows[index]=rows[changeIndex];
    rows[changeIndex]=curRow;
    $dg.datagrid('refreshRow',index).datagrid('refreshRow',changeIndex).datagrid('unselectAll').datagrid('selectRow',changeIndex);
    var idArr=new Array();
    for(var i=0;i<rows.length;i++){
        var ID=rows[i].ID;
        if(ID) idArr.push(ID);
    }
    var selected=$('#tabFav').datagrid('getSelected');
    var ItemID=selected.id.split('_')[1];
    var ret=$.cm({
        ClassName:'DHCDoc.Diagnos.Fav',
        MethodName:MethodName,
        ItemID:ItemID,
        UserID:session['LOGON.USERID'],
        IDStr:JSON.stringify(idArr),
        dataType:'text'
    },false);
    if(ret=='0'){
        //$.messager.popover({msg:'位置调整成功',type:'success'});
    }else{
        parent.$.messager.alert('提示','位置调整失败:'+ret,'warning');
    }
    return true;
}
function DisableToolbar($dg,disable)
{
    if(disable){
        $dg.parent().prev('.datagrid-toolbar').find('a.l-btn').linkbutton('disable');
    }else{
        $dg.parent().prev('.datagrid-toolbar').find('a.l-btn').linkbutton('enable');
    }
}
function FavEditClick()
{
	websys_showModal({
		iconCls:'icon-w-batch-cfg',
		url:"diagnos.template.maintain.csp",
		title:$g('模板维护'),
		width:'85%',height:'80%'
	});
}