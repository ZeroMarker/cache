var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var startIndex = undefined;
var editIndex=undefined;
var orowid=""
$(function(){//��ʼ��
    
    Init();
}); 

function Init(){
	var YMboxObj = $HUI.combobox("#Databox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetCategory",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'fdesc',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    var TravelToolObj = $HUI.combobox("#Toolbox",{
	    valueField:'id', 
	    textField:'text',
	    defaultFilter:4,
	    data:[
			{id:'����',text:'����'}
			,{id:'����',text:'����'}
			,{id:'��',text:'��'}
			,{id:'�ɻ�',text:'�ɻ�'}
			,{id:'����',text:'����'}
			,{id:'����',text:'����'}
			,{id:'��������',text:'��������'}
			,{id:'��������',text:'��������'}
		],
    });
    
    
    var YMboxObj = $HUI.combobox("#NDatabox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetCategory",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'fdesc',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    var TravelToolObj = $HUI.combobox("#NToolbox",{
	    valueField:'id', 
	    textField:'text',
	    defaultFilter:4,
	    data:[
			{id:'����',text:'����'}
			,{id:'����',text:'����'}
			,{id:'��',text:'��'}
			,{id:'�ɻ�',text:'�ɻ�'}
			,{id:'����',text:'����'}
			,{id:'����',text:'����'}
			,{id:'��������',text:'��������'}
			,{id:'��������',text:'��������'}
		],
    });
    
    MainColumns=[[
    
    {
	    field:"ckbox",
	    checkbox:true,
    },
    {
	    field:'rowid',
	    title:'ID',
	    width:80,
	    hidden: true
    },
    {
	    field:'CompDR',
	    title:'ҽԺID',
	    width:80,
	    hidden: true
	    
    },
    {
	    field:'AddStart',
	    title:'�����ص�',
	    width:150,
	    align:'left',    
    },
    {
	    field:'AddEnd',
	    title:'Ŀ�ĵص�',
	    width:150,
	    align:'left',
    },
    {
	    field:'TravelTool',
	    title:'��ͨ����',
	    width:150,
	    align:'left',   
    },
    {
	    field:'TravelValue',
	    title:'��׼����',
	    width:150,
	    align:'left',
	    formatter:dataFormat,
	    type:'numberbox',
	    options:{precision: 2}
    },
    {
	    field:'Category',
	    title:'��Ա����',
	    width:150,
	    formatter:function(value,row){
						return row.FDesc;
					},                
    }
    ]];
    
    var MainGridObj = $HUI.datagrid("#MainGrid",{
	    url:$URL,
	    queryParams:{
		    ClassName:'herp.budg.hisui.udata.uBudgVehicle',
		    MethodName:'List',
		    hospid: hospid,
		    AddStart: '',
		    AddEnd: '',
		    TravelTool: '',
		    TravelValue: '',
		    Category: ''
	    },
	    fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        singleSelect:true,
        rownumbers:true,//�к�
        singleSelect: true, //ֻ����ѡ��һ��
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //���û����һ�е�ʱ�򴥷�
        onLoadSuccess:function(data){
            
        },
        onClickCell: function(index,field,value){   //���û����һ����Ԫ���ʱ�򴥷�
            
        },
        toolbar: [
        	{
	        	id: 'AddBn',
            	iconCls: 'icon-add',
           		text: '����'
        	},{
	        	id: 'EditBn',
	        	iconCls: 'icon-write-order',
				text:'�޸�'
		    },{
	        	id: 'DeleteBn',
	        	iconCls: 'icon-cancel',
	        	text: 'ɾ��'
        	}]     
    });
    
    //�ж��Ƿ�����༭
	function FYDEndEditing() {

		if (startIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', startIndex)) {
			var ed = $('#MainGrid').datagrid('getEditor', {
					index: startIndex,
					field: 'Code'
				});
			$('#MainGrid').datagrid('endEdit', startIndex);
			startIndex = undefined;
			return true;
		} else {
			return false;
		}
	}   
	
	//����һ��
    var AddRow = function(row){
	
	    if (FYDEndEditing()) {
				$('#MainGrid').datagrid('appendRow', {	
				});
				startIndex = $('#MainGrid').datagrid('getRows').length - 1;
				$('#MainGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);
		}
    }
    
    $("#AddBn").click(function(){
	   $('#MainGrid').datagrid('clearChecked')
	     clear();
	     $HUI.dialog('#CreateWin').open()
	  });
	  
	  
	  $("#EditBn").click(function(){
	     //$HUI.dialog('#CreateWin').open()
	      var row=$('#MainGrid').datagrid('getChecked')[0];
        
         orowid=row.rowid
        
	     if(orowid==""){
		     return ;
	     }
	     Select(orowid);
	  });
	  
	  //���һ��ʱ������
    function onClickRow(index){
        //var row=$('#MainGrid').datagrid('getRows')[index];  
        
        //alert(row.rowid)
        //$('#MainGrid').datagrid("beginEdit", index);             
    }
    $("#DeleteBn").click(function(){
	    var grid=$('#MainGrid');
        var rows = $('#MainGrid').datagrid("getSelections");
        
        if (CheckDataBeforeDel(rows) == true) {
            del(grid,"herp.budg.hisui.udata.uBudgVehicle","Delete")
            //DFindBtn();
        } else {
            return;
        }
    });
    
    function CheckDataBeforeDel(rows) {
        if(!rows.length){
            $.messager.popover({
		        msg:'��ѡ����Ҫɾ�����У�',
		        timeout: 2000,type:'alert',
		        showType: 'show',
		        style:{"position":"absolute","z-index":"9999",
		               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		               top:0.5}}); 
                return;
           };
        return true;
    };
    
    // ��ѯ����
    var DFindBtn= function()
    {
	    var AddStart=$('#citySelect').val();
	    var AddEnd=$('#citySelectTwo').val();
	    var TravelTool=$('#Toolbox').combobox('getValue');
	    var Category=$('#Databox').combobox('getValue');
         MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgVehicle",
                MethodName:"List",
                hospid: hospid,
		        AddStart: AddStart,
		        AddEnd: AddEnd,
		        TravelTool: TravelTool,
		        TravelValue: "",
		        Category: Category
            })
    }

    // �����ѯ��ť 
    $("#FindBn").click(DFindBtn);
    
    // �����ѯ��ť 
    $("#SuerBT").click(function(){
	     Save();
	  });
	  
	  $HUI.linkbutton('#CancelBT',{
		  onClick:function(){
			 $HUI.dialog('#CreateWin').close();
		  }
	  });
	  
	  var clear=function (){
		$("#citySelectThree").val("");
	    $("#citySelectFour").val("");
	    $("#TravelValue").val("");
	    $('#NToolbox').combobox('setValue',"");
	    $('#NDatabox').combobox('setValue',"")
	}
	
	var Save= function()
    {
	    
		var AddStart = $("#citySelectThree").val();
		//alert(TravelStatr)
		if (AddStart == '') {
			$.messager.popover({
				msg: '�������в���Ϊ��!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		}
		var AddEnd = $("#citySelectFour").val();
		//alert(TravelEnd)
		if (AddEnd == '') {
			$.messager.popover({
				msg: 'Ŀ�ĳ��в���Ϊ��!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		}

		var TravelValue = $("#TravelValue").val();
		if (TravelValue == '') {
			$.messager.popover({
				msg: '��׼���ò���Ϊ��!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		} 
		var TravelTool = $("#NToolbox").combobox('getValue');
		//alert(TravelTool)
		if (TravelTool == '') {
			$.messager.popover({
				msg: '��ͨ���߲���Ϊ��!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		}
		var Category = $("#NDatabox").combobox('getValue');
		
		if (Category == '') {
			$.messager.popover({
				msg: '��Ա�����Ϊ��!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		}
		//var data=code+"|"+address+"|"+desc+"|"+user+"|"+ps+"|"+fold+"|"+hospid;
		//AddStart, AddEnd, TravelTool, TravelValue, Category, CompDR
	    var row=$('#MainGrid').datagrid("getSelected");
	    if (row==null){
		    var rorowid=""
		    }else{
			    rorowid=row.rowid}
	    $.m({
				 ClassName:'herp.budg.hisui.udata.uBudgVehicle',
				 MethodName:'Save',
				 AddStart : AddStart,
				 AddEnd: AddEnd,
				 TravelTool : TravelTool,
				 TravelValue : TravelValue,
				 Category : Category,
				 CompDR : hospid,
				 rowid: rorowid 
		},
		function(Data){
			      if(Data==0){
					 $.messager.popover({
		                msg: '����ɹ���',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:0.5}});
						 //$('#MainGrid').datagrid("reload");
						 $HUI.dialog('#CreateWin').close();
						 DFindBtn();   	  
							      	 
					}else{
						$.messager.popover({
		                msg: '����ʧ�ܣ�'+Data,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:0.5}
				        });
								    
					}
		});
	    
	    
	        
    }
    
    var Select=function (rowid){
	    var mianinfo=tkMakeServerCall("herp.budg.hisui.udata.uBudgVehicle","Select",rowid);
	     //alert(mianinfo)
		
		var arrinfo=mianinfo.split("^")
		//alert(arrinfo)
	    $("#citySelectThree").val(arrinfo[0]);
	    $("#citySelectFour").val(arrinfo[1]);
	    $("#TravelValue").val(arrinfo[3]);
	    $('#NToolbox').combobox('setValue', arrinfo[2]);
	    $('#NDatabox').combobox('setValue', arrinfo[4]);
	    $HUI.dialog('#CreateWin').open()
    }
    //DFindBtn();
    
    
    
    
    
    
    
    
    
    
    
    
    
    
      
     
    
     
	 
           
        
        
         
       
		
		
	  
				  
	       
	
	
	
}


 