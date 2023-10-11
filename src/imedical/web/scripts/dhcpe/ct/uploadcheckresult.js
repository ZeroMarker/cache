/*
 * FileName: dhcpe/ct/uploadcheckresult.js
 * Author: ln
 * Date: 2022-06-15
 * Description: �豸ά������
 */
 
var tableName = "DHC_PE_UpLoadResult";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

 $(function(){
	
	//��ȡ���������б�
	GetLocComp(SessionStr)
	       	
	InitCombobox();
	
	//��ʼ�� �豸ά��Grid
	InitUpResultGrid();
	
	//��ʼ�� �豸ά������Grid
	InitUpResultDetailGrid();
	
	//���������б�change
	$("#LocList").combobox({
       onSelect:function(){
	        var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
			BClear_click();
			
			$("#UpResultGrid").datagrid('load',{
				ClassName:"web.DHCPE.CT.UpLoadCheckResult",
				QueryName:"FindUpLoadResult",
				Code:$("#Code").val(),
				Desc:$("#Desc").val(),
				NoActive:$("#URNoActive").checkbox('getValue') ? "Y" : "N",
				LocID:LocID
			})
		   
		}
		
	});
	
	
    
	//��ѯ
     $('#BFind').click(function(){
    	BFind_click();
    });
    
	//����
     $('#BClear').click(function(){
    	BClear_click();
    });
    
    //����
     $('#BAdd').click(function(){
    	BAdd_click();
    });
    
    //�޸�
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
    
	//����(�豸����ά��)
     $('#BLClear').click(function(){
    	BLClear_click();
    });
    
    //����(�豸����ά��)
     $('#BLAdd').click(function(){
    	BLAdd_click();
    });
    
    //�޸�(�豸����ά��)
     $('#BLUpdate').click(function(){
    	BLUpdate_click();
    });
    
    //����(�豸����ά��)
     $('#BLSave').click(function(){
    	BLSave_click();
    });
   
    //��ѯ(�豸����ά��)
     $('#BLFind').click(function(){
    	BLFind_click();
    });
 
})



/*******************************�豸ά�� start*************************************/
//��ѯ
function BFind_click(){
	$("#UpResultGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.UpLoadCheckResult",
		QueryName:"FindUpLoadResult",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		NoActive:$("#URNoActive").checkbox('getValue') ? "Y" : "N",
		LocID:$("#LocList").combobox('getValue')
			
	});	
}

//����
function BClear_click(){
	$("#ID,#Code,#Desc").val("");
	$("#URNoActive").checkbox('setValue',true);
	BFind_click();
	BLFind_click();

}

//����
function BAdd_click(){
	
	BSave_click("0");	
}

//�޸�
function BUpdate_click()
{
	BSave_click("1");
}

function BSave_click(Type){
	
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	if(Type=="0"){
		if($("#ID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		var ID="";
	}
	var LocID=$("#LocList").combobox('getValue')
	if (""==LocID) {
		$("#LocList").focus();
		$.messager.alert("��ʾ","���Ҳ���Ϊ��","info");
		return false;
	}
	
	var Code=$("#Code").val();
	if (""==Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	   	});
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	   	});
		$.messager.alert("��ʾ","��������Ϊ��","info");
		return false;
	}
	
	var iURNoActive="N";
	var URNoActive=$("#URNoActive").checkbox('getValue');
	if(URNoActive) iURNoActive="Y"
	
	var UserID=session['LOGON.USERID'];
	
	var InfoStr=LocID+"^"+Code+"^"+Desc+"^"+iURNoActive+"^"+UserID;
	
	//alert("InfoStr:"+InfoStr)
	
	var ret=tkMakeServerCall("web.DHCPE.CT.UpLoadCheckResult","UpdateUpLoadResult",ID,InfoStr);
	var Arr=ret.split("^");
	if (Arr[0]>0){
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ�',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});}
		BClear_click();		
	}else{
		$.messager.alert("��ʾ",Arr[1],"error");	
	} 	
	
}

function InitUpResultGrid()
{
	$HUI.datagrid("#UpResultGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.UpLoadCheckResult",
			QueryName:"FindUpLoadResult",
			NoActive:$("#URNoActive").checkbox('getValue') ? "Y" : "N"
			
		},
		frozenColumns:[[
			{field:'TCode',title:'����',width: 60},
			{field:'TDesc',title:'����',width: 150},
			
		]],
		columns:[[
	
		    {field:'id',title:'id',hidden: true},
			{field:'TNoActive',title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
       		},
			{field:'TUpdateDate',title:'��������',width: 120},
			{field:'TUpdateTime',title:'����ʱ��',width: 120},
			{field:'TUserName',title:'������',width: 120}
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
			$("#ID").val(rowData.id);
			$("#Desc").val(rowData.TDesc);
			$("#Code").val(rowData.TCode);
			$('#UpResultDetailGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			BLClear_click();
		
		}
	});
}

/*******************************�豸ά�� end*************************************/


/*******************************�豸ά������ start*************************************/

 //��ѯ(�豸����ά��)
function BLFind_click(){
	
	$("#UpResultDetailGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.UpLoadCheckResult",
		QueryName:"FindLocUpLoadResult",
		LURID:$("#ID").val(),
		ARCIMDR:$("#ARCIMDesc").combogrid("getValue")
	})		
}


//����
function BLClear_click(){
	
	$("#LURID,#PENoSepB,#PENoSepA,#ImgPath,#JCSJSepB,#JCSJSepA,#ZDYJSepB,#ZDYJSepA").val("");
	$("#ARCIMDesc").combogrid('setValue',"");
	BLFind_click();
	
}
//����
function BLAdd_click()
 {
	lastIndex = $('#UpResultDetailGrid').datagrid('getRows').length - 1;
	$('#UpResultDetailGrid').datagrid('selectRow', lastIndex);
	var selected = $('#UpResultDetailGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#UpResultDetailGrid').datagrid('appendRow', {
		TID: '',
		TCategory: '',
		TSort: '',
		TPlace: '',
		TDocSignName: '',
		TPatSignName: '',
		TNoActive: ''
		
			});
	lastIndex = $('#UpResultDetailGrid').datagrid('getRows').length - 1;
	$('#UpResultDetailGrid').datagrid('selectRow', lastIndex);
	$('#UpResultDetailGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BLUpdate_click()
 {
	var selected = $('#UpResultDetailGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#UpResultDetailGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#UpResultDetailGrid').datagrid('beginEdit', thisIndex);
		$('#UpResultDetailGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#UpResultDetailGrid').datagrid('getSelected');
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TARCIMDesc'  
			});
		
		$(thisEd.target).combobox('select', selected.TARCIM); 

		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TImgPath'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPENoSepB'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPENoSepA'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPENoSepB'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJCSJSepA'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TJCSJSepA'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TZDYJSepB'  
			});
			
		var thisEd = $('#UpResultDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TZDYJSepA'  
			});
			
	}
 }

//TID,TARCIM,TARCIMDesc,TImgPath,TPENoSepB,TPENoSepA,TJCSJSepB,TJCSJSepA,TZDYJSepB,TZDYJSepA,TTextInfo,TUpdateDate,TUpdateTime,TUserName
//����
function BLSave_click()
{
	var UserID=session['LOGON.USERID'];
	var URDR=$("#ID").val();
	if(URDR==""){
		$.messager.alert("��ʾ","��ѡ���豸","info");
		return false;
	}
	
	$('#UpResultDetailGrid').datagrid('acceptChanges');
	var selected = $('#UpResultDetailGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TID == "") {
			if ((selected.TARCIMDesc == "undefined") || (selected.TImgPath == "undefined")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadUpResultDetailGrid();
				return;
			}

			var iARCIMID=selected.TARCIMDesc;	
			if((iARCIMID != "") && (iARCIMID.split("||").length < 2)) {
				$.messager.alert("��ʾ","��ѡ��ҽ����!","info");
				return false;
			}
	
			if (iARCIMID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMID);
				if (ret == "0") {
					$.messager.alert("��ʾ","��ѡ��ҽ����!","info");
					return false;
				}
			}

			var InfoStr=URDR+"^"+selected.TARCIMDesc+"^"+selected.TImgPath+"^"+selected.TPENoSepB+"^"+selected.TPENoSepA+"^"+selected.TJCSJSepB+"^"+selected.TJCSJSepA+"^"+selected.TZDYJSepB+"^"+selected.TZDYJSepA+"^"+selected.TTextInfo+"^"+UserID
			$.m({
				
				ClassName: "web.DHCPE.CT.UpLoadCheckResult",
				MethodName: "UpdateLocUpLoadResult",
				ID:selected.TID,
				InfoStr:InfoStr
						
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', '����ʧ��:'+ rtnArr[1], 'error');
					
				}else{
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});	
				}
			
				
				LoadUpResultDetailGrid();
			});
		} else {
			$('#UpResultDetailGrid').datagrid('selectRow', EditIndex);
			var selected = $('#UpResultDetailGrid').datagrid('getSelected');
			if ((selected.TARCIMDesc == "undefined") || (selected.TImgPath == "undefined")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				LoadUpResultDetailGrid();
				return;
			}

			var iARCIMID=selected.TARCIMDesc;	
			if((iARCIMID != "") && (iARCIMID.split("||").length < 2)) {
				$.messager.alert("��ʾ","��ѡ��ҽ����!","info");
				return false;
			}
	
			if (iARCIMID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMID);
				if (ret == "0") {
					$.messager.alert("��ʾ","��ѡ��ҽ����!","info");
					return false;
				}
			}

		   //var InfoStr=URDR+"^"+selected.TARCIMDesc+"^"+selected.TImgPath+"^"+selected.TPENoSepB+"^"+selected.TPENoSepA+"^"+selected.TJCSJSepB+"^"+selected.TJCSJSepA+"^"+selected.TZDYJSepB+"^"+selected.TZDYJSepA+"^"+selected.TTextInfo+"^"+UserID
			var InfoStr=URDR+"^"+iARCIMID+"^"+selected.TImgPath+"^"+selected.TPENoSepB+"^"+selected.TPENoSepA+"^"+selected.TJCSJSepB+"^"+selected.TJCSJSepA+"^"+selected.TZDYJSepB+"^"+selected.TZDYJSepA+"^"+selected.TTextInfo+"^"+UserID
		
			$.m({
				
				ClassName: "web.DHCPE.CT.UpLoadCheckResult",
				MethodName: "UpdateLocUpLoadResult",
				ID:selected.TID,
				InfoStr:InfoStr
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', '�޸�ʧ��:'+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});	
				}
			
				LoadUpResultDetailGrid();
			});
		}
	}
}
function LoadUpResultDetailGrid()
{
	 $("#UpResultDetailGrid").datagrid('reload');
}



function InitUpResultDetailGrid()
{
	$HUI.datagrid("#UpResultDetailGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		columns: LocUpLoadResultColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.UpLoadCheckResult",
			QueryName:"FindLocUpLoadResult",
			LURID:$("#ID").val()
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

//����  
var LocUpLoadResultColumns = [[
	{
		field:'TID',
		title:'ID',
		hidden:true
	},{
		field:'TARCIM',
		title:'ARCIM',
		hidden:true
	},{
		field:'TARCIMDesc',
		width: '230',
		title:'ҽ����',
		formatter:function(value,row){
            return row.TARCIMDesc;
         },
		editor:{
           type:'combobox',
           options:{
	            required: true,
                valueField:'STORD_ARCIM_DR',
                textField:'STORD_ARCIM_Desc',
                 mode:'remote', 
          		onShowPanel: function () { // ֻ������������ʾʱ,��ȥ����url��ȡ����,��������ٶ�
					var url = $(this).combobox('options').url;
					if (!url){
						//$(this).combobox('options').mode = 'remote';
						var url = $URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array";
						$(this).combobox('reload',url);		
						}
					},

               // url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.Desc = param.q;
					param.Type="B";
					param.LocID=$('#LocList').combobox('getValue');
					param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$('#LocList').combobox('getValue'));         
                  }
                        
               }
         }
	},{
		field:'TImgPath',
		width: '200',
		title:'ͼƬ�ļ�',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TPENoSepB',
		width: '150',
		title:'��ȡ���ŷָ���ǰ',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TPENoSepA',
		width: '150',
		title:'��ȡ���ŷָ�����',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TJCSJSepB',
		width: '150',
		title:'��ȡ��������ָ���ǰ',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field:'TJCSJSepA',
		width: '150',
		title:'��ȡ��������ָ�����',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field:'TZDYJSepB',
		width: '150',
		title:'��ȡ�������ָ���ǰ',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field:'TZDYJSepA',
		width: '150',
		title:'��ȡ�������ָ�����',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'validatebox',
		}
	},{
		field: 'TTextInfo',
		width: '90',
		title: '��ȡ�ı�',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		}
						
	  }
	},{
		field: 'TUpdateDate',
		width: '120',
		title: '��������'
	}, {
		field: 'TUpdateTime',
		width: '120',
		title: '����ʱ��'
	}, {
		field: 'TUserName',
		width: '120',
		title: '������'
	}	
	
	
	
]];

/*******************************�豸ά������ end*************************************/
function InitCombobox()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID;}
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

    //ҽ����
    var InvDefaultFeeObj = $HUI.combogrid("#ARCIMDesc",{
        panelWidth:470,
        url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastListNew",
        mode:'remote',
        delay:200,
        pagination : true, 
        pageSize: 20,
        pageList : [20,50,100],
        idField:'STORD_ARCIM_DR',
        textField:'STORD_ARCIM_Desc',
        onBeforeLoad:function(param){
            param.Desc = param.q;
            param.Type="B";
            param.LocID=LocID;
            param.hospId = hospId;

        },
        columns:[[
            {field:'STORD_ARCIM_DR',hidden:true},
            {field:'STORD_ARCIM_Code',title:'ҽ������',width:100},
            {field:'STORD_ARCIM_Desc',title:'ҽ������',width:240}
            
            
            
        ]]
    });
	
}

