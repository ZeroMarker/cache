/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchangeaccessflag����
function checkchangeaccessflag(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var row = $('#groupequiptypedatagrid').datagrid('getRows')[rowIndex];
		if (row) {
			//messageShow("","","",row.ck.checked);
			if(TAccessCheckbox.checked==true) row.accessflag="Y"
    		else row.accessflag="N"
    		$('#groupequiptypedatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#groupequiptypedatagrid').datagrid('selectRow',rowIndex)
			//$('#groupequiptypedatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:����checkchangedefaultflag����
function checkchangedefaultflag(TAccessCheckbox,rowIndex)
{
		//var row = $('#menudatagrid').datagrid('getSelected');
		var rows = $('#groupequiptypedatagrid').datagrid('getRows');
		var row=rows[rowIndex];
		if (row) {
			//messageShow("","","",row.ck.checked);
			if(TAccessCheckbox.checked==true) 
			{
				row.defaultflag="Y";
				for(var i=0;i<rows.length;i++) {
					if ((rows[i].defaultflag="Y")&&(i!=rowIndex))
					{
						rows[i].defaultflag="N"
						$('#groupequiptypedatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
						index:i,
						row:rows[i]})
					}  
				}
			}
			else row.defaultflag="N"
    		//var rowIndex = $('#menudatagrid').datagrid('getRowIndex', row);
    		$('#groupequiptypedatagrid').datagrid('updateRow',{	//�ڱ����ĳ�������а���ͬ�¼�ʱ������Ӧ�������¼�������ִ��updateRow���������±��onclick�¼�ʧЧ
			index:rowIndex,
			row:row})
			$('#groupequiptypedatagrid').datagrid('selectRow',rowIndex)
			//$('#groupequiptypedatagrid').datagrid('options').onClickRow(rowIndex,row)
		}
}
$(document).ready(function () {
   var str=window.location.search.substr(1);
   var list=str.split("&");
   var tmp=list[0].split("=");
   var tid=tmp[1];
   //messageShow("","","",tid);
$('#groupequiptypedatagrid').datagrid({   
    url:'dhceq.jquery.csp', 
    queryParams:{
        ClassName:"web.DHCEQCGroupEquipType",
        QueryName:"GetGroupEquipType",
        Arg1:tid,
        ArgCnt:1
    },
    border:'true',
    //height:'100%',
    toolbar:[{          
                iconCls: 'icon-save',
                text:'����',          
                handler: function(){
                     SavegridData();
                }     
                 }] , 
   
    columns:[[
    	{field:'rowid',title:'LRowid',width:50,hidden:true},    
        //{field:'groupdr',title:'groupdr',width:150,align:'center',hidden:true},
        //{field:'defaultflag',title:'defaultflag',width:150,align:'center',hidden:true},
        {field:'groupdr',title:'groupdr',width:150,align:'center',hidden:true},
        {field:'equiptypedr',title:'equiptypedr',width:150,align:'center',hidden:true}, 
        {field:'equiptype',title:'����',width:150,align:'center'}, 
        {field:'defaultflag',title:'Ĭ��',width:100,align:'center',formatter: defaultflagOperation},   /// Modfied by zc 2015-07-30 ZC0027   
        {field:'accessflag',title:'����',width:100,align:'center',formatter: accessflagOperation},    /// Modfied by zc 2015-07-30 ZC0027             
    ]],
    singleSelect: true,
	selectOnCheck: true,
	checkOnSelect: true,
	onLoadSuccess:function(data){                    
       if(data){
            $.each(data.rows, function(index, item){
                if(item.checked){
                   $('#groupequiptypedatagrid').datagrid('checkRow', index);
               }
 
           });

        }},
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]    
});
function editrow(target){
			$('#groupequiptypedatagrid').datagrid('beginEdit', getRowIndex(target));
		}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�defaultflagOperation����		
function defaultflagOperation(value,row,index){
			if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangedefaultflag(this,'+index+')" checked="checked"  >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox1" onclick="checkchangedefaultflag(this,'+index+')"  >';
		}

}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�accessflagOperation����	
function accessflagOperation(value,row,index)
{
	if(value=="Y"){
			return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchangeaccessflag(this,'+index+')" checked="checked"  >';
		}
		else{
		return '<input type="checkbox" name="DataGridCheckbox" onclick="checkchangeaccessflag(this,'+index+')" >';
	}
}
/// Modfied by zc 2015-07-30 ZC0027
/// ����:�޸�SavegridData����
function SavegridData(){
	/*var checkedItems = $('#groupequiptypedatagrid').datagrid('getChecked');
	messageShow("","","",checkedItems.length);
    var names = [];
    $.each(checkedItems, function(index, item){
	        var id=item.TDefault;
	        messageShow("","","",id);
	        //alertShow($('#ck').is(':checked'));
		
        }); */
        //var row = $('#groupequiptypedatagrid').datagrid('getRows')
        //messageShow("","","",row.TDefault);
   var effectRow = new Object();    
   effectRow["data"]=JSON.stringify($('#groupequiptypedatagrid').datagrid('getRows'))
   //messageShow("","","",effectRow["data"]); 
   eval(" effectRow[\"data\"] = '"+effectRow["data"]+"';");
      $.post("dhceq.jquery.operationtype.csp?&action=updategroupequiptype", effectRow, function(text, status) {
                            if(status=="success"){
                                $.messager.show({
                				title: '��ʾ',
                				msg: '����ɹ�' })
                                //$('#menudatagrid').datagrid('acceptChanges');
                                $('#groupequiptypedatagrid').datagrid('reload');
                            }
                        }, "text").error(function() { //JSON����������Ҫ����Content-Type���ԣ�
                            $.messager.show({
                				title: '��ʾ',
                				msg: '����ʧ��' })
                            $('#groupequiptypedatagrid').datagrid('reload');
                        })                  
		               
}

});
/// Modfied by zc 2015-07-30 ZC0027
/*$.extend($.fn.datagrid.methods, {
   getChecked: function (jq) {
        var rr = [];
       var rows = jq.datagrid('getRows'); 
       jq.datagrid('getPanel').find('div.datagrid-cell input:TDefault').each(function () {
           var index = $(this).parents('tr:first').attr('datagrid-row-index');
           rr.push(rows[index]);
       });
       return rr;
    }
});*/