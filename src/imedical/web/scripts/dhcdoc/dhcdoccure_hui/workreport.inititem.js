var PageSizeItemObj={
	m_SelectArcimID:"",
	PUBLIC_WORKREPORT_CLASSNAME:"DHCDoc.DHCDocCure.WordReport",
	PUBLIC_APPLY_CLASSNAME:"DHCDoc.DHCDocCure.Apply",
	PUBLIC_CONFIG_CLASSNAME:"DHCDoc.DHCDocCure.Config"
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=3
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=3
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=3
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=3
}

function InitDate(){
	/*var date=new Date();
    var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var Today= y+'-'+m+'-'+d;
    $('#StartDate').datebox('setValue', Today);	
    $('#EndDate').datebox('setValue', Today);		
    */
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"DateLogicalToHtml",
		'h':"",
		dataType:"text"   
	},false);
    $("#StartDate,#EndDate").datebox('setValue',CurDay);		
}

function InitLoc(){
	var UserHospID=Util_GetSelUserHospID();	
	$HUI.combobox("#ComboLoc", {})
    $.cm({
		ClassName:PageSizeItemObj.PUBLIC_CONFIG_CLASSNAME,
		QueryName:"FindLoc",
		'Loc':"",
		'CureFlag':"1",
		'Hospital':UserHospID,
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboLoc", {
				valueField: 'LocRowID',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
	$HUI.combobox("#ComboOrderLoc", {})
    $.cm({
		ClassName:PageSizeItemObj.PUBLIC_CONFIG_CLASSNAME,
		QueryName:"FindLoc",
		'Loc':"",
		'CureFlag':"",
		'Hospital':UserHospID,
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboOrderLoc", {
				valueField: 'LocRowID',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}
		 });
	});
}


function InitLocComGrid()
{
    $HUI.combogrid("#ComboLoc",{ 
    	panelWidth:305,
		panelHeight:340,
		delay: 300,    
		//url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		mode: 'remote',
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//�Ƿ��ҳ   
		rownumbers:true,//���   
		collapsible:false,//�Ƿ���۵���   
		fit: true,//�Զ���С   
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
		pageList: [10],//��������ÿҳ��¼�������б�   
		method:'post',  
		idField:'LocRowID',  
    	textField:'LocDesc',
    	//multiple:true,
    	columns: [[    
	        {field:'LocDesc',title:'����',width:150,sortable:true},
	        {field:'LocRowID',title:'ID',width:50,align: 'center',sortable:true} 
	    ]] ,  
		keyHandler: {
			up: function () {
                //ȡ��ѡ����
                var selected = $('#ComboLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //ȡ��ѡ���е�rowIndex
                    var index = $('#ComboLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //�����ƶ�����һ��Ϊֹ
                    if (index > 0) {
                        $('#ComboLoc').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#ComboLoc').combogrid('grid').datagrid('getRows');
                    $('#ComboLoc').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //ȡ��ѡ����
                var selected = $('#ComboLoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //ȡ��ѡ���е�rowIndex
                    var index = $('#ComboLoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //�����ƶ�����ҳ���һ��Ϊֹ
                    if (index < $('#ComboLoc').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#ComboLoc').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#ComboLoc').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
                var selected = $('#ComboLoc').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      $('#ComboLoc').combogrid("options").value=selected.LocRowID;
			    }
                $('#ComboLoc').combogrid('hidePanel');
            },
			query:function(q){
				var object1=new Object();
				object1=$(this)
				$('#ComboLoc').combogrid("clear");
				$('#ComboLoc').combogrid("setValue",q);
				LoadLocData(q,object1);
            }
		},
		onSelect: function (){
			var selected = $('#ComboLoc').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
				$('#ComboLoc').combogrid("options").value=selected.LocRowID;
			}else{
				$('#ComboLoc').combogrid("options").value="";	
			}
		},
		onShowPanel: function (){
			var object1=new Object();
			object1=$(this)
			LoadLocData("",object1);
		}
	});

};

function LoadLocData(q,obj)
{
	var desc=q;
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_CONFIG_CLASSNAME,
		QueryName:"FindLoc",
		'Loc':desc,
		'CureFlag':"1",
		Pagerows:obj.combogrid("grid").datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		obj.combogrid("grid").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function InitDoc(){
	$HUI.combobox("#ComboDoc", {})
 	var LocRowId=session['LOGON.CTLOCID'];
    $.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"OPDoclookup",
		'locid':LocRowId,
		'RDocdesc':"",
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#ComboDoc", {
				valueField: 'rowid',
				textField: 'OPLocdesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["OPLocdesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				
		 });
	});
}

function InitDocComGrid()
{
	var LocRowId=session['LOGON.CTLOCID']; //$("#ComboLoc").combobox('getValue');
	$HUI.combogrid("#"+"ComboDoc"+"",{ 
		panelWidth:305,
		panelHeight:350,
		delay: 300,    
		//url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		mode: 'remote',
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//�Ƿ��ҳ   
		rownumbers:true,//���   
		collapsible:false,//�Ƿ���۵���   
		fit: true,//�Զ���С   
		pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
		pageList: [10],//��������ÿҳ��¼�������б�   
		method:'post',  
		idField:'rowid',  
    	textField:'OPLocdesc',
    	columns: [[    
	        {field:'OPLocdesc',title:'ҽ��',width:130,sortable:true},
	        {field:'rowid',title:'ID',width:50,align: 'center',sortable:true} 
	    ]] ,  
		keyHandler: {
			up: function () {
                //ȡ��ѡ����
                var selected = $('#ComboDoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //ȡ��ѡ���е�rowIndex
                    var index = $('#ComboDoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //�����ƶ�����һ��Ϊֹ
                    if (index > 0) {
                        $('#ComboDoc').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#ComboDoc').combogrid('grid').datagrid('getRows');
                    $('#ComboDoc').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //ȡ��ѡ����
                var selected = $('#ComboDoc').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //ȡ��ѡ���е�rowIndex
                    var index = $('#ComboDoc').combogrid('grid').datagrid('getRowIndex', selected);
                    //�����ƶ�����ҳ���һ��Ϊֹ
                    if (index < $('#ComboDoc').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#ComboDoc').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#ComboDoc').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
                var selected = $('#ComboDoc').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      $('#ComboDoc').combogrid("options").value=selected.rowid;
			    }else{
					$('#ComboDoc').combogrid("options").value="";
				}
                $('#ComboDoc').combogrid('hidePanel');
            },
			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					//this.AutoSearchTimeOut=window.setTimeout("LoadItemData('"+q+"','"+$(this)+"')",400)
					this.AutoSearchTimeOut=window.setTimeout(function(){ LoadDocData(LocRowId,q);},400); 
				}else{
					//this.AutoSearchTimeOut=window.setTimeout("LoadItemData('"+q+"','"+$(this)+"')",400)
					this.AutoSearchTimeOut=window.setTimeout(function(){ LoadDocData(LocRowId,q);},400); 
				}
				$(this).combogrid("setValue",q);				
            }
		},
		onSelect: function (){
			var selected = $('#ComboDoc').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
				$('#ComboDoc').combogrid("options").value=selected.rowid;
			}else{
				$('#ComboDoc').combogrid("options").value="";	
			}
		},
		onShowPanel: function (){
			LoadDocData(LocRowId,"");
		}
	});     
};

function LoadDocData(LocRowId,q)
{
	var desc=q;
	$.cm({
		ClassName:PageSizeItemObj.PUBLIC_WORKREPORT_CLASSNAME,
		QueryName:"OPDoclookup",
		'locid':LocRowId,
		'RDocdesc':desc,
		Pagerows:$('#ComboDoc').combogrid("grid").datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		$('#ComboDoc').combogrid("grid").datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})	
}

function InitArcimDesc()
{
	$("#ComboArcim").lookup({
        url:$URL,
        mode:'remote',
        disabled:false,
        method:"Get",
        idField:'ArcimRowID',
        textField:'ArcimDesc',
        columns:[[  
            {field:'ArcimDesc',title:'����',width:320,sortable:true},
			{field:'ArcimRowID',title:'ID',width:100,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:420,
        panelHeight:260,
        isCombo:true,
        minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5],
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: PageSizeItemObj.PUBLIC_APPLY_CLASSNAME,QueryName: 'FindAllItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
	        var CureItemFlag="on"
			param = $.extend(param,{'Alias':desc,'CureItemFlag':CureItemFlag,'SubCategory':""});
	    },onSelect:function(ind,item){
            var Desc=item['desc'];
			var ID=item['ArcimRowID'];
			PageSizeItemObj.m_SelectArcimID=ID;
			$HUI.lookup("#ComboArcim").hidePanel();
		},onHidePanel:function(){
            var gtext=$HUI.lookup("#ComboArcim").getText();
            if((gtext=="")){
	        	PageSizeItemObj.m_SelectArcimID="";    
	        }
		}
    });  
};

function InitResGroup(){
	if(typeof(Util_GetSelHospID)=="function"){
		var HospDr=Util_GetSelHospID(); //common.util.js
	}else{
		var HospDr=Util_GetSelUserHospID();	
	}
	$HUI.combobox('#ResGroup',{      
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.RBCServiceGroupSet&QueryName=QueryServiceGroup&HospID="+HospDr+"&ResultSetType=array",
	});
}

function Util_GetSelUserHospID(){
	var HospID="";
	if($('#_HospUserList').length>0){
		HospID=$HUI.combogrid('#_HospUserList').getValue();
	}
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	return HospID;
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="ArcimDesc"){
			var CombValue=Data[i].ArcimRowID;
		 	var CombDesc=Data[i].ArcimDesc;
	     }else{
		    var CombValue=Data[i].Rowid  
		 	var CombDesc=Data[i].Desc
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
