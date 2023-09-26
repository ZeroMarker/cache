var editFlag="undefined";
var Columns=getCurColumnsInfo('PLAT.G.Config.ComponentItem','','','')
var GlobalObj = {
	///modified by zy 20191202 ZY0197
	///����DataType��DisplayType  �����ֶε�����.
	///DataType���ڼ�¼Ԫ�ص��ֶ�����
	///DisplayTyp���ڿ���Ԫ����ʾ�����ݺͱ༭״̬�µ�����
	//0:text,1:link,2:button,3:checkbox,4:icheckbox,5:switchbox,6:numberbox,7:combobox,8:validatebox,9:combogrid,10:datebox,11:datetimebox,12:combotree,13:textare
	DisplayTypeValue : [{"value":"","text":""},{"value":"0","text":"text"},{"value":"1","text":"link"},{"value":"2","text":"button"},{"value":"3","text":"checkbox"},{"value":"4","text":"icheckbox"},{"value":"5","text":"switchbox"},{"value":"6","text":"numberbox"},{"value":"7","text":"combobox"},{"value":"8","text":"validatebox"},{"value":"9","text":"combogrid"},{"value":"10","text":"datebox"},{"value":"11","text":"datetimebox"},{"value":"12","text":"combotree"},{"value":"13","text":"textare"}],	//json��ʽ,  ,{"value":"5","text":"combogrid"}
	//0:string,1:int,2:float,3:date,4:time,5:bool
	DataTypeValue : [{"value":"","text":""},{"value":"0","text":"string"},{"value":"1","text":"int"},{"value":"2","text":"float"},{"value":"3","text":"date"},{"value":"4","text":"time"},{"value":"5","text":"bool"}],	//add by lmm 2018-12-06 {"value":"1","text":"textarea"},{"value":"3","text":"numberbox"},{"value":"4","text":"validatebox"},
	ComponentID : $("#ComponentID").val()
	/*
	ClearData : function(vElementID)
	{
		if (vElementID=="AssetType") {this.AssetTypeDR = "";}
	},
	ClearAll : function()
	{
		this.AssetTypeDR = "";
	},
	GetData: function()
	{
		this.ComponentID=$("#ComponentID").val()
	}
	*/
}
$(document).ready(function()
{
	initDocument();
	defindTitleStyle(); 
	$HUI.datagrid("#DHCEQCComponent",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQCComponent",
	        	QueryName:"GetComponentItem",
				ComponentID:GlobalObj.ComponentID
		},
	    toolbar:[{
    			iconCls: 'icon-save',
                text:'����',  
				id:'save',        
                handler: function(){
                     saveAllData();
                }},'----------',
                {
                iconCls: 'icon-add',
                text:'����',
				id:'add',
                handler: function(){
                     insertRow();
                }}
                /*
                ,'----------',
				{
				iconCls:'icon-cut',
				text:'ɾ��',
				handler:function(){deleteAllData();}
				}*/
                ],
		//rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
	    singleSelect:true,
		//fitColumns:true,    //modify by lmm 2018-11-07 734076
		pagination:true,
		striped : true,
	    cache: false,
		columns:Columns,
	    onSelect: function (rowIndex, rowData) {//������ȡ���༭
	    	if (editFlag!="undefined") 
	    	{
                jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag); 
            }
        },
	    onDblClickRow: function (rowIndex,rowData) {//����ѡ���б༭
	    	if (editFlag!="undefined")
	    	{
                jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag); 
            }
            jQuery("#DHCEQCComponent").datagrid('beginEdit', rowIndex);
            editFlag =rowIndex;            
           
           
        },
		//onClickRow:function(rowIndex,rowData){onClickRow();},
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){}
	});
	changeColumnOption()
});
function initDocument()
{
	//GlobalObj.GetData();
	FillData();
}

function FillData()
{
	if (GlobalObj.ComponentID=="") return;
	//modify by lmm 2018-11-28 begin
	var data=tkMakeServerCall("web.DHCEQCComponent","GetOneComponent",GlobalObj.ComponentID);
	data=data.replace(/\ +/g,"")	//ȥ���ո�
	data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
	var list=data.split("^");
	setElement("Name",list[0])
	setElement("Caption",list[1])
	setElement("CaptionStyle",list[2])
	setElement("ClassName",list[3])
	setElement("QueryName",list[4])
	setElement("Template",list[5])
	setElement("Specification",list[6])
	setElement("Remark",list[7])
	setElement("Hold1",list[12])
	setElement("Hold2",list[13])
	setElement("Hold3",list[14])
	setElement("DefaultSize",list[15])   //modify by lmm 2020-03-05 LMM0062
	setElement("Hold5",list[16])
}

function CombineData()
{
	var val="";
	val=GlobalObj.ComponentID;
	val+="^"+getElementValue("Name");
	val+="^"+getElementValue("Caption");
	val+="^"+getElementValue("CaptionStyle");
	val+="^"+getElementValue("ClassName");
	val+="^"+getElementValue("QueryName");
	val+="^"+getElementValue("Template");
	val+="^"+getElementValue("Specification");
	val+="^"+getElementValue("Remark");
	//modify by lmm 2020-03-05 LMM0062 BEGIN
	val+="^"+getElementValue("Hold1");   //SysFlag
	val+="^"+getElementValue("Hold2");   //ValueItemDR
	val+="^"+getElementValue("Hold3");   //DescItemDR
	val+="^"+getElementValue("DefaultSize");   //DefaultSize   
	//modify by lmm 2020-03-05 LMM0062 END
	val+="^"+getElementValue("Hold5");
	
	return val;
}
function ListData()
{
	var ListData=""
	if(editFlag>="0"){
		jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag);
	}
	/*
	var rows = jQuery("#DHCEQCComponent").datagrid('getRows');
	if(rows.length<=0){
		return ListData;
	}
	*/
	var rows = jQuery("#DHCEQCComponent").datagrid('getRows');    //modify by lmm 2018-11-14
	if(rows.length<=0) return ListData;
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if(rows[i].TName=="") return -1;
		//add by lmm 2019-11-19 LMM0049
		
		//modified by ZY0203
		//if((rows[i].TDataType!="")&&(rows[i].TDisplayOnly=="Y"))  return -2   //modify by lmm 2019-11-19 LMM0052
		var tmp=""
		tmp=rows[i].TRowID
		tmp=tmp+"^"+rows[i].TName
		tmp=tmp+"^"+rows[i].TCaption
		tmp=tmp+"^"+rows[i].TCaptionStyle
		tmp=tmp+"^"	//+rows[i].TClassMethod
		tmp=tmp+"^"	//+rows[i].TClassMethodIfDirty
		tmp=tmp+"^"	//+rows[i].TCustomExpression
		tmp=tmp+"^"+rows[i].TDataType      //modify by lmm 2018-12-06
		tmp=tmp+"^"	//+rows[i].TDefaultValueAlways
		tmp=tmp+"^"	//+rows[i].TDefaultValueExpression
		tmp=tmp+"^"	//+rows[i].TDescription
		tmp=tmp+"^"	//+rows[i].TDisabled
		tmp=tmp+"^"+rows[i].TDisplayOnly  //modify by lmm 2018-12-06
		tmp=tmp+"^"+rows[i].TDisplayType
		tmp=tmp+"^"	//+rows[i].THelpUrl
		tmp=tmp+"^"+rows[i].THidden
		tmp=tmp+"^"+rows[i].TImage
		tmp=tmp+"^"	//+rows[i].TLinkComponent
		tmp=tmp+"^"	//+rows[i].TLinkConditionalExp
		tmp=tmp+"^"+rows[i].TLinkExpression
		tmp=tmp+"^"+rows[i].TLinkUrl
		tmp=tmp+"^"	//+rows[i].TLinkWorkFlow
		tmp=tmp+"^"	//+rows[i].TListCellStyle
		tmp=tmp+"^"	//+rows[i].TLookupBrokerMethod
		tmp=tmp+"^"	//+rows[i].TLookupClassName
		tmp=tmp+"^"+rows[i].TLookupCustomComponent    //modify by lmm 2019-02-18
		tmp=tmp+"^"+rows[i].TLookupJavascriptFunction
		tmp=tmp+"^"	//+rows[i].TLookupProperties
		tmp=tmp+"^"	//+rows[i].TLookupQueryName
		tmp=tmp+"^"	//+rows[i].TLookupUserDefined
		tmp=tmp+"^"	//+rows[i].TLookupUserDefinedValues
		tmp=tmp+"^"	//+rows[i].TNestedComponent
		tmp=tmp+"^"	//+rows[i].TNestedCondExpr
		tmp=tmp+"^"	//+rows[i].TOrderMode
		tmp=tmp+"^"	//+rows[i].TPassword
		tmp=tmp+"^"	//+rows[i].TReadOnly
		tmp=tmp+"^"	//+rows[i].TReferencedObject
		tmp=tmp+"^"	//+rows[i].TRequired
		tmp=tmp+"^"	//+rows[i].TShortcutKey
		tmp=tmp+"^"+rows[i].TShowInNewWindow
		tmp=tmp+"^"+rows[i].TStyle
		tmp=tmp+"^"	//+rows[i].TTabSequence
		tmp=tmp+"^"	//+rows[i].TTooltip
		tmp=tmp+"^"	//+rows[i].TValueGet
		tmp=tmp+"^"	//+rows[i].TValueSet
		//add by lmm 2018-11-14
		tmp=tmp+"^"	//sort
		tmp=tmp+"^"	//IdField
		tmp=tmp+"^"	//TextField
		tmp=tmp+"^"	//JsFunction
		tmp=tmp+"^"+rows[i].TFrozen    //add by lmm 2018-11-09
		//add by lmm 2018-11-14
		dataList.push(tmp);
	}
	var ListData=dataList.join("#");
	return ListData
}


function saveAllData()
{
	if (getElementValue("Name")=="")
	{
		$.messager.alert('����ʧ�ܣ�','������Ʋ���Ϊ��', 'warning')
		return;
	}
	var Val=CombineData()
	var ValList=ListData()

	if (ValList=="-1")
	{
		$.messager.alert('����ʧ�ܣ�','��ϸ���Ʋ���Ϊ��', 'warning')
		return;
	}
	//add by lmm 2019-11-19 LMM0049
	if (ValList=="-2")
	{
		$.messager.alert('����ʧ�ܣ�','ѡ��<��������>����ѡ<�ɱ༭>', 'warning')
		return;
	}
	//add by lmm 2019-11-19 LMM0049
	//modify by jyp 2018-11-23
	var Data=tkMakeServerCall("web.DHCEQCComponent","SaveData",Val,ValList,0);
	if (Data<0) {messageShow("alert","error","������ʾ",Data);return;}
	messageShow("alert","success","��ʾ","�޸ĳɹ���");
	window.setTimeout(function(){window.location.href= "dhceq.plat.ctcomponent.csp?&ComponentID="+Data;},50);
	//modify by jyp 2018-11-23
}

// ��������
function insertRow()
{
	if(editFlag>="0"){
		jQuery("#DHCEQCComponent").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	jQuery("#DHCEQCComponent").datagrid('appendRow', {//��ָ����������ݣ�appendRow�������һ���������
	//modify by lmm 2019-10-29 1072573 LMM0048
	TRowID: '',TName:'',TCaption: '',TCaptionStyle:'',TStyle:'',THidden: '',TDisplayType: '',TImage: '',TLinkUrl: '',TLinkExpression: '',TShowInNewWindow: '',TLookupJavascriptFunction: '',TFrozen: '',TDataType: '',TDisplayOnly: '',TLookupCustomComponent:''}  //modify by lmm 2018-11-14
	);
	//jQuery("#DHCEQCComponent").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editFlag=0;
}

function deleteRow(index){
    $.messager.confirm('ȷ��','ȷ��ɾ��?',function(r){
        if (r){
            
			var row = jQuery('#DHCEQCComponent').datagrid('getRows')[index];
			
			if (row.TRowID=="")
			{
				$('#DHCEQCComponent').datagrid('deleteRow', index);
			}
			else if (row.TRowID>0)
			{
				//modify by lmm 2018-11-28 begin
				var data=tkMakeServerCall("web.DHCEQCComponent","DeleteItemData",row.TRowID);
				if(data==0)
				{
					$('#DHCEQCComponent').datagrid('deleteRow', index);
				}
				else if(data<0)
				{
					$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
				}
				else if(data>0)
				{
					$.messager.alert('ɾ��ʧ�ܣ�','��'+data+'���ط��õ���Ԫ��,����ɾ��.', 'warning');
				}
				//modify by lmm 2018-11-28 end
			}
        }
    });
}
function deleteAllData()
{
	if(GlobalObj.ComponentID==""){$.messager.alert('��ʾ','��ǰ���������','warning');return;}
	$.messager.confirm('ȷ��', '��ȷ��Ҫɾ����ѡ������', function(b)
	{
		if (b==false){return;}
        else
        {
			//modify by lmm 2018-11-28 begin
			var data=tkMakeServerCall("web.DHCEQCComponent","DeleteData",GlobalObj.ComponentID);
			if(data>=0)
			{
				$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
				$('#DHCEQCComponent').datagrid('reload');
				ClearElement();
			}
			else
				$.messager.alert('ɾ��ʧ�ܣ�','�������:'+data, 'warning');
		}
				//modify by lmm 2018-11-28 end        
	});
}
function checkboxHiddenChange(THidden,rowIndex)
{
	var row = jQuery('#DHCEQCComponent').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (THidden==key)
			{
				if (((val=="N")||val=="")) row.THidden="Y"
				else row.THidden="N"
			}
		})
	}
}
///add by lmm 2018-10-14
function changeColumnOption()
{
	var TDisplayTypeDesc=$("#DHCEQCComponent").datagrid('getColumnOption','TDisplayTypeDesc');	
	TDisplayTypeDesc.editor={type: 'combobox',options:{
					data: GlobalObj.DisplayTypeValue,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#DHCEQCComponent").datagrid('getEditor',{index:editFlag,field:'TDisplayType'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#DHCEQCComponent").datagrid('getEditor',{index:editFlag,field:'TDisplayTypeDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	TDisplayTypeDesc.formatter=	function(value,row){
			return row.TDisplayTypeDesc;
		}
	var TAction=$("#DHCEQCComponent").datagrid('getColumnOption','TAction');
	TAction.formatter=	function(value,row,index){
			return '<a href="#" onclick="deleteRow('+index+')">ɾ��</a>';		
		}
	
	//add by lmm 2018-12-06 end		
	var TDataTypeDesc=$("#DHCEQCComponent").datagrid('getColumnOption','TDataTypeDesc');	
	TDataTypeDesc.editor={type: 'combobox',options:{
					data: GlobalObj.DataTypeValue,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#DHCEQCComponent").datagrid('getEditor',{index:editFlag,field:'TDataType'});
						//modify by lmm 2019-11-13 LMM0049
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#DHCEQCComponent").datagrid('getEditor',{index:editFlag,field:'TDataTypeDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	TDataTypeDesc.formatter=	function(value,row){
			return row.TDataTypeDesc;
		}
	//add by lmm 2018-12-06 end		
}
///add by lmm 2018-11-09 ���Ӷ��Ṵѡ����
function checkboxFrozenChange(TFrozen,rowIndex)
{
	var row = jQuery('#DHCEQCComponent').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TFrozen==key)
			{
				if (((val=="N")||val=="")) row.TFrozen="Y"
				else row.TFrozen="N"
			}
		})
	}
}
///add by lmm 2018-11-09 ���Ӷ��Ṵѡ����
function checkboxDisplayOnlyChange(TDisplayOnly,rowIndex)
{
	var row = jQuery('#DHCEQCComponent').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TDisplayOnly==key)
			{
				if (((val=="N")||val=="")) row.TDisplayOnly="Y"
				else row.TDisplayOnly="N"
			}
		})
	}
}
