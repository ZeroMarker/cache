var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
var startIndex = undefined;
var editIndex=undefined;
var orowid=""
$(function(){//��ʼ��
    Init();
}); 
//rowid^Code^IP^Desc^Desc1^Desc2^Desc3^Desc4^CompName^Password
function Init(){
    MainColumns=[[ 
                {
	                field:'ck',
	                checkbox:true
	            }, 
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'ҽ�Ƶ�λ',width:80,hidden: true},
                {field:'Code',title:'���������',align:'center',width:140},
                {field:'IP',title:'�������ַ',align:'left',width:140},
                {field:'Desc',title:'������Ϣ',align:'left',width:140},
                {field:'Desc1',title:'�û�',align:'left',width:140},
                {field:'Password',title:'����',align:'left',width:140},
                {field:'Desc3',title:'�ļ���',align:'left',width:140}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgConfig",
            MethodName:"List",
            hospid : "", 
            Code:  "",
            Desc :    "",
            IP:""
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
            del(grid,"herp.budg.hisui.udata.uBudgConfig","Delete")
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
     //sortField, sortDir, start, limit, hospid
    var DFindBtn= function()
    {
	    var code=$('#qcode').val();
	    var adress=$('#qaddress').val();
	    var desc=$('#qdesc').val();
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgConfig",
                MethodName:"List",
                hospid : "", 
                Code:  code,
                Desc :    desc,
                IP:adress
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
		$("#ccode").val("");
	    $("#caddress").val("");
	    $("#cdesc").val("");
	    $("#cuser").val("");
	    $("#cps").val("");
	    $("#cfold").val("");
	}
    var Save= function()
    {
	    
		var code = $("#ccode").val();
		if (code == '') {
			$.messager.popover({
				msg: '��������벻��Ϊ��!',
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
		var address = $("#caddress").val();
		if (address == '') {
			$.messager.popover({
				msg: '�������ַ����Ϊ��!',
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

		var desc = $("#cdesc").val();
		if (desc == '') {
			$.messager.popover({
				msg: '������Ϣ����Ϊ��!',
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
		var user = $("#cuser").val();
		if (user == '') {
			$.messager.popover({
				msg: '�û�������Ϊ��!',
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
		var ps = $("#cps").val();
		if (ps == '') {
			$.messager.popover({
				msg: '���벻��Ϊ��!',
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
		var fold = $("#cfold").val();
		if (fold == '') {
			$.messager.popover({
				msg: '�ļ��в���Ϊ��!',
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
		
		var data=code+"|"+address+"|"+desc+"|"+user+"|"+ps+"|"+fold+"|"+hospid;
	    var row=$('#MainGrid').datagrid("getSelected");
	    if (row==null){
		    var rorowid=""
		    }else{
			    rorowid=row.rowid}
	    $.m({
				 ClassName:'herp.budg.hisui.udata.uBudgConfig',
				 MethodName:'Save',
				 data : data,
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
	    var mianinfo=tkMakeServerCall("herp.budg.hisui.udata.uBudgConfig","Select",rowid);
		var arrinfo=mianinfo.split("^")
	    $("#ccode").val(arrinfo[0]);
	    $("#caddress").val(arrinfo[1]);
	    $("#cdesc").val(arrinfo[2]);
	    $("#cuser").val(arrinfo[3]);
	    $("#cps").val(arrinfo[4]);
	    $("#cfold").val(arrinfo[5]);
	    $HUI.dialog('#CreateWin').open()
    }
    //DFindBtn();
}