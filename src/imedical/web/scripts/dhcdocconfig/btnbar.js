$(function(){
    $.extend(GenHospComp("DocCFTreatStatusMainInfo").jdata.options,{
        onSelect:function(index,row){
			$("#tabPageList").singleGrid('reload');
        },
        onLoadSuccess:function(data){
            InitPageList();
            InitBtnList();
        }
    });
});
function InitPageList()
{
    $("#tabPageList").singleGrid({
		clsName:'User.DocCFTreatStatusMainInfo',
		idField:'TreatStatusConfigMainID',
		border:false,
		useBaseToolbar:true,
		toolbar:[{
			text:'����������Ժ��',
			iconCls: 'icon-copy',
			handler: function(){
				var selected=$("#tabPageList").datagrid('getSelected');
				if(!selected){
					$.messager.popover({msg:"��ѡ���踴�ư�ť��ҳ��",type:'alert'});
					return false;
				}
				$('#HospList').empty();
				$('#CpoyWin').window('open');
				$.cm({
					ClassName:'DHCDoc.DHCDocConfig.BtnBar',
					QueryName:'QueryHospital'
				},function(data){
					var HospID=$('#_HospList').getValue()
					$.each(data.rows,function(index,row){
						if(HospID==row.id) return true;
						$('#HospList').append('<option value ="'+row.id+'">'+row.text+'</option')
					});
				});
			}
		}],
		queryParams:{ClassName : "DHCDoc.DHCDocConfig.BtnBar",QueryName : "QueryPage"},
		columns :[[
			{field:'TreatStatusConfigMainID',hidden:true},
			{field:'HospDr',hidden:true},
			{field:'CSPname',title:'��ť������',width:150,editor:{type:'text',options:{}}},
			{field:'DefiDesc',title:'��ť������',width:200,editor:{type:'text',options:{}}},
			{field:'IsActive',title:'����',width:50,align:'center',
				editor:{
					type: 'icheckbox',
					options:{
						on:'1',
						off:'0'
					}
				},
                styler: function(value,row,index){
                    return value==1?'color:#21ba45;':'color:#f16e57;';
                },
                formatter:function(value,record){
                    return value==1?'��':'��';
                }
            }
		]],
		getInitRow:function(){
			return {IsActive:1,HospDr:$('#_HospList').getValue()};
		},
		checkSaveRows:function(rows){
			for(var i=rows.length-1;i>=0;i--){
				if((rows[i].CSPname=='')||(rows[i].DefiDesc=='')){
					if(rows[i].TreatStatusConfigMainID){
						$.messager.popover({msg:"��ť�����������Ʋ���Ϊ��",type:'alert'});
						return false;
					}
					rows.splice(i,1); 
				}
			}
			return rows;
		},
		onBeforeLoad:function(param){
			param.HospID=$('#_HospList').getValue();
		},
		onSelect:function(index, row) {
            $("#tabBtnList").datagrid('reload');
		},
		onBeginEdit:function(index,row){
			var ed = $(this).datagrid('getEditor', {index:index,field:'CSPname'});
			$(ed.target).select();
		}
	});
}
function InitBtnList()
{
    $("#tabBtnList").singleGrid({
		clsName:'User.DocCFTreatStatusInfo',
		idField:'TreatStatusConfigID',
		border:false,
		useBaseToolbar:true,
		toolbar:[{
            text:'����',
            iconCls: 'icon-arrow-top',
            handler: function(){
                if($("#tabBtnList").singleGrid('moveSelRow','UP')){
					UpdateBtnSeq();
				}
            }
        },'-',{
            text:'����',
            iconCls: 'icon-arrow-bottom',
            handler: function(){
                if($("#tabBtnList").singleGrid('moveSelRow','DOWN')){
					UpdateBtnSeq();
				}
            }
        }],
        fitColumns:false,
		queryParams:{ClassName : "DHCDoc.DHCDocConfig.BtnBar",QueryName : "QueryPageBtn"},
		columns :[[
			{field:'TreatStatusConfigID',hidden:true},
			{field:'TreatStatusConfigMainID',hidden:true},
			{field:'toolId',title:'����',width:150,editor:{type:'text',options:{}}},
			{field:'name',title:'����',width:200,editor:{type:'text',options:{}}},
			{field:'iconStyle',title:'ͼ��',width:200,editor:{type:'text',options:{}}},
			{field:'clickHandler',title:'�����¼�',width:200,editor:{type:'text',options:{}}},
 			{field:'tooltip',title:'������ʾ�ı�',width:120,editor:{type:'text',options:{}}},
 			{field:'shortcut',title:'��ݼ�',width:60,editor:{type:'text',options:{}}},
 			{field:'express',title:'��ʾ���ʽ',width:250,editor:{type:'text',options:{}}},
 			{field:'URLconfig',title:'����',width:200,editor:{type:'text',options:{}}},
            {field:'customStyle',title:'�Ų���ʽ',width:200,editor:{type:'text',options:{}}},
            {field:'liteCustomStyle',title:'������ʽ',width:200,editor:{type:'text',options:{}}},
			{field:'prevGroupFlag',title:'����',width:70,align:'center',
				editor:{
					type: 'icheckbox',
					options:{
						on:'1',
						off:'0'
					}
				},
				formatter:function(value,record){
					if (value=="1") return "��";
					return "";
				},
				styler: function(value,row,index){
					if (value=="1"){
						return 'color:#21ba45;';
					}
				}
			},
 			{field:'IsActive',title:'�Ƿ���Ч',width:70,align:'center',
				editor:{
					type: 'icheckbox',
					options:{
						on:'1',
						off:'0'
					}
				},
 				formatter:function(value,record){
		 			if (value=="1") return "��";
		 			else  if (value=="0") return "��";
		 		},
 				styler: function(value,row,index){
	 				if (value=="1"){
		 				return 'color:#21ba45;';
		 			}else if(value=="0"){
			 			return 'color:#f16e57;';
			 		}
 				}
 			}
		]],
		getInitRow:function(){
			var selected=$('#tabPageList').datagrid('getSelected');
			if(!selected){
				$.messager.popover({msg:"��ѡ�������Ӱ�ť��ҳ��",type:'alert'});
                return false;
			}
			var TreatStatusConfigMainID=selected.TreatStatusConfigMainID;
			if(!TreatStatusConfigMainID){
				$.messager.popover({msg:"���ȱ���ҳ�����ά����ť",type:'alert'});
                return false;
			}
			return {IsActive:1,TreatStatusConfigMainID:TreatStatusConfigMainID};
		},
		checkSaveRows:function(rows){
			var selected=$('#tabPageList').datagrid('getSelected');
			if(!selected){
				$.messager.popover({msg:"��ѡ�������Ӱ�ť��ҳ��",type:'alert'});
                return false;
			}
			if(!selected.TreatStatusConfigMainID){
				$.messager.popover({msg:"���ȱ���ҳ�����ά����ť",type:'alert'});
                return false;
			}
			for(var i=rows.length-1;i>=0;i--){
				if(rows[i].toolId==''){
					if(rows[i].TreatStatusConfigID){
						$.messager.popover({msg:"��ť���벻��Ϊ��",type:'alert'});
						return false;
					}
					rows.splice(i,1); 
				}
			}
			return rows;
		},
		onBeginEdit:function(index,row){
			var ed = $(this).datagrid('getEditor', {index:index,field:'shortcut'});
			$(ed.target).attr('readOnly',true).keydown(function(e){
				e.preventDefault();
				window.onhelp = function(){ return false };
				if((e.keyCode<37)||(e.keyCode>135)) return false;
				var keyName=e.key||window.event.code;
				if(keyName.indexOf('Digit')==0) keyName=keyName.split('Digit')[1];
				if(keyName.indexOf('Key')==0) keyName=keyName.split('Key')[1];
				keyName=keyName.toUpperCase();
				if(e.shiftKey) keyName='Shift+'+keyName;
				if(e.ctrlKey) keyName='Ctrl+'+keyName;
				$(this).val(keyName);
				return false;
			});
			var ed = $(this).datagrid('getEditor', {index:index,field:'toolId'});
			$(ed.target).select();
		},
		onBeforeLoad:function(param){
            var selected=$("#tabPageList").datagrid('getSelected');
            if(!selected) return false;
			$(this).datagrid('unselectAll');
			param.PageID=selected.TreatStatusConfigMainID;
		}
	});
}
function CopyPageClick()
{
	var selected=$("#tabPageList").datagrid('getSelected');
	if(!selected){
		$.messager.popover({msg:"��ѡ���踴�ư�ť��ҳ��",type:'alert'});
		return false;
	}
	var SelHospArr=new Array();
	$('#HospList').find("option:selected").each(function(){
		SelHospArr.push($(this).val());
	});
	if(!SelHospArr){
		$.messager.popover({msg:"��ѡ��Ŀ��Ժ��",type:'alert'});
		return false;
	}
	var ret=$.cm({
		ClassName:'DHCDoc.DHCDocConfig.BtnBar',
		MethodName:'CopyPage',
		PageID:selected.TreatStatusConfigMainID,
		ToHospIDs:JSON.stringify(SelHospArr),
		dataType:'text'
	},false);
	if(ret==0){
		$.messager.popover({msg:"����ɹ�",type:'success'});
		$('#CpoyWin').window('close');
	}else{
		$.messager.alert('��ʾ','����ʧ��:'+ret);
	}
}
function UpdateBtnSeq()
{
	var idField=$("#tabBtnList").datagrid('options').idField||'ID';
	var rows=$("#tabBtnList").datagrid('getRows');
	var idArr=new Array();
    for(var i=0;i<rows.length;i++){
        var ID=rows[i][idField];
        if(ID) idArr.push(ID);
    }
	var ret=$.cm({
        ClassName:'DHCDoc.DHCDocConfig.BtnBar',
        MethodName:'UpdateBtnSeq',
        IDStr:JSON.stringify(idArr),
        dataType:'text'
    },false);
    if(ret=='0'){
        //$.messager.popover({msg:'λ�õ����ɹ�',type:'success'});
    }else{
        $.messager.alert('��ʾ','λ�õ���ʧ��:'+ret,'warning');
    }
}