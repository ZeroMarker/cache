Detail = function(){ 
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];   
     
    DetailColumns=[[  
                {field:'ckbox',checkbox:true},//��ѡ��
                {field:'rowid',title:'��ϸID',width:80,hidden: true},
	            {field:'projadjdr',title:'����ID',width:80,hidden:true},
                {field:'fundtypedr',title:'�ʽ����ID',width:80,hidden: true},
                {field:'fundtype',title:'�ʽ����',width:120},
                {field:'itemcode',title:'��Ŀ����',width:120},
                {field:'itemname',title:'��Ŀ����',width:120},
                {field:'bidlevel',title:'Ԥ�㼶��',width:120,hidden:true},
                {field:'bidislast',title:'�Ƿ�ĩ��',width:120,hidden:true},
                {field:'budgprice',title:'Ԥ�㵥��(Ԫ)',width:120},
                {field:'budgnum',title:'Ԥ������',width:120},
                {field:'budgvalue',title:'Ԥ����(Ԫ)',width:120},
                {field:'budgpro',title:'��Ԥ��ռ��(%)',width:120},
                {field:'username',title:'������',width:120},
                {field:'deptdr',title:'�����˿���ID',width:120,hidden:true},
                {field:'deptname',title:'�����˿���',width:150,},
                {field:'state',title:'״̬',width:60,hidden:true},
                {field:'isaddeditlist',title:'����/����',width:120,hidden:true},
                {field:'isaddedit',title:'����/����',width:120},
                {field:'budgdesc',title:'�豸���Ʊ�ע',width:180},
	            {field:'PerOrigin',title:'��Ա����-ԭ���豸',width:180},
	            {field:'FeeScale',title:'�շѱ�׼',width:120},
	            {field:'AnnBenefit',title:'��Ч��Ԥ��',width:150},
	            {field:'MatCharge',title:'�Ĳķ�',width:120},
	            {field:'SupCondit',title:'��������',width:120},
	            {field:'Remarks',title:'˵��',width:200},
	            {field:'brand1',title:'�Ƽ�Ʒ��1',width:150},
	            {field:'spec1',title:'����ͺ�1',width:150},
	            {field:'brand2',title:'�Ƽ�Ʒ��2',width:150},
	            {field:'spec2',title:'����ͺ�2',width:150},
	            {field:'brand3',title:'�Ƽ�Ʒ��3',width:150},
	            {field:'spec3',title:'����ͺ�3',width:150}
            ]];
    var DetailGridObj = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablish",
            MethodName:"ListDetail",
            hospid :    hospid, 
            projadjdr :    ""          
        },
        delay:200,
        fitColumns: false,
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        rownumbers:true,//�к�
		striped:true,
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:DetailColumns,
        toolbar: '#dtb'       
    }); 
	
	//��֤������	
	function ChkPef(){
	if(($('#BItembox').combobox('getValue')=="")||($('#BPricebox').val()=="")||($('#BNumbox').val()=="")||($('#BDeptbox').combobox('getValue')=="")||($('#BAEbox').combobox('getValue')=="")){
		$.messager.popover({
					msg: '��ѡ���Ϊ�գ�',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				});
				return false;
	}
	return true;	
	};

    //����
	var AddBtn=function(){
    //δѡ����ϸ����ʾ��Ϣ
	var rowObj = $('#MainGrid').datagrid('getSelected');
	var rows = $('#MainGrid').datagrid('getSelections');
	if(rows.length!=1){
	$.messager.popover({
					msg: '��ѡ��һ����Ŀ!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
	};		
		var $win; 
		$("#Detailff").form('clear');
		$win = $('#Add').window({
				title: '�����Ŀ��ϸ��Ϣ',
				width: 800,
				height: 575,
				top: ($(window).height() - 600) * 0.5,
				left: ($(window).width() - 900) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-add',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //�رչرմ��ں󴥷�
					$("#DetailGrid").datagrid("reload"); //�رմ��ڣ����¼�����ϸ���
				}
			});
		$win.window('open');
	// Ԥ���Ŀ��������
    var AddItemObj = $HUI.combobox("#BItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            //param.year 	 = $('#BYMbox').combobox('getValue');
            //param.deptdr = $('#BDutybox').combobox('getValue');
            param.str 	 = param.q;
        },
	});
    // �ʽ����͵�������
    var AddFundTyObj = $HUI.combobox("#BFundTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
        mode:'remote',
        valueField:'fundTypeId',    
        textField:'fundTypeNa',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
    });
	// Ԥ����ҵ�������
    var AddBgDeptObj = $HUI.combobox("#BDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Deptnamelist",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
	// ����/����
	var BAEboxObj = $HUI.combobox("#BAEbox",{
		mode:'remote',
		valueField:'id',
		textField:'text',
		data:[{id:'1',text:'����'},{id:'2',text:'����'}]
	});
	//Ԥ�㵥�۱仯������Ԥ����
    $('#BPricebox').keyup(function(event){
    	Calcu();
    })
    //Ԥ�������仯������Ԥ����
    $('#BNumbox').numberspinner({
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //����Ԥ���� = ����*���� 
    function Calcu(){
    	var AddPrice = parseFloat($('#BPricebox').val());  //Ԥ�㵥��
    	if (AddPrice ==""||isNaN(AddPrice)){AddPrice = 0};
    	var AddNum = parseFloat($('#BNumbox').val()); //Ԥ������
    	if (AddNum ==""||isNaN(AddNum)){AddNum = 0};
    	$('#BSumbox').val(AddPrice.toFixed(2)*AddNum.toFixed(0));
    }
	$("#BtchSave").unbind('click').click(function(){
		var fundtype=$('#BFundTypebox').combobox('getValue');//�ʽ�����
		var bannben=$('#BAnnBenbox').val();//��Ч��Ԥ��
		var bitem=$('#BItembox').combobox('getValue');//Ԥ���Ŀ
		var bmatchar=$('#BMatCharbox').val();//�Ĳķ�
		var bprice =$('#BPricebox').val();//Ԥ�㵥��
		var bsupcon =$('#BSupConbox').val();//��������
		var bnum =$('#BNumbox').val();//Ԥ������
		var bremar =$('#BRemarkbox').val();//˵��
		var bsum =$('#BSumbox').val();//Ԥ����
		var bbrand1 =$('#BBrand1box').val();//�Ƽ�Ʒ��1
		var bperce =$('#BPercebox').val();//Ԥ����ռ��
		var bspec1 =$('#BSpec1box').val();//����ͺ�1
		var bdept =$('#BDeptbox').combobox('getValue');//Ԥ�����
		var bbrand2 =$('#BBrand2box').val();
		var bae =$('#BAEbox').combobox('getValue');//����/����
		var bspec2 =$('#BSpec2box').val();
		var bequremark =$('#BEquRemarkbox').val();//�豸���Ʊ�ע
		var bbrand3 =$('#BBrand3box').val();
		var bfeesca =$('#BFeeScabox').val();//�շѱ�׼
		var bspec3 =$('#BSpec3box').val();
		var bperori =$('#BPerOribox').val();//��Ա���ʡ�ԭ���豸
		
	
	
    if(ChkPef()==true){
		//��ȡ��������,����ID,��ȡ������
		var rows = $('#MainGrid').datagrid('getSelections');
		for(var i=0;i<rows.length;i++){
			var year=rows[i]['year'];
            var projadjdr=rows[i]['projadjdr'];	
            var uname=rows[i]['username'];			
		};
		//alert(year);
		//alert (projadjdr);
		//alert(uname);
		//alert(bdept);
		var datad = projadjdr + '|' + year + '|' + bitem + '|' + bprice + '|' + bnum + '|' + bsum 
		+ '|' + bequremark + '|' + bfeesca + '|' + bannben + '|' + bmatchar + '|' + bsupcon 
		+ '|' + bremar + '|' + bbrand1 + '|' + bspec1 + '|' + bbrand2 + '|' + bspec2 
		+ '|' + bbrand3 + '|' + bspec3 + '|' + bae + '|' + bperori + '|' + userid 
		+ '|' + uname + '|' + fundtype + '|' + bperce + '|' + hospid + '|' + bdept;
		//alert(datad);
		$.m({
            ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',MethodName:'InsertDetail',data:datad},
            function(Data){
                if(Data==0){
                    $.messager.popover({
					msg: "����ɹ���",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
          
                }
            }
        );
		$win.window('close');
	};	
		
	});
    $("#BtchClose").unbind('click').click(function(){
        $win.window('close');
    });
    }
	//���������ť
	$("#AddBn").click(AddBtn);
	
	
	//�޸�
	var UpdaBtn=function(){
	//δѡ����ϸ����ʾ��Ϣ
	var rowObj = $('#DetailGrid').datagrid('getSelected');
	var rowMainObj = $('#MainGrid').datagrid('getSelected');
	var rows = $('#DetailGrid').datagrid('getSelections');
	if(rows.length!=1){
	$.messager.popover({
					msg: '��ѡ��һ�������޸�!',
					type: 'alert',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top:10
					}
				}); ;
				return false;
	};
	$("#Detailff").form('clear');
		var $win; 
		$win = $('#Add').window({
				title: '�޸���Ŀ��ϸ��Ϣ',
				width: 800,
				height: 575,
				top: ($(window).height() - 600) * 0.5,
				left: ($(window).width() - 900) * 0.5,
				shadow: true,
				modal: true,
				iconCls: 'icon-write-order',
				closed: true,
				minimizable: false,
				maximizable: false,
				collapsible: false,
				resizable: true,
				onClose: function () { //�رչرմ��ں󴥷�
					$("#DetailGrid").datagrid("reload"); //�رմ��ڣ����¼��������
				}
			});
	    $win.window('open');
		var rowid = rowObj.rowid;//��ϸID
		var year = rowMainObj.year;//�������
		var uname = rowMainObj.username;//������
		var projadjdr = rowObj.projadjdr;//����ID
		var fundtype=rowObj.fundtypedr;//�ʽ�����
		var bannben=rowObj.AnnBenefit;//��Ч��Ԥ��
		var itemcode=rowObj.itemcode;
		var bitem=rowObj.itemname;//Ԥ���Ŀ
		var bmatchar=rowObj.MatCharge;//�Ĳķ�
		var bprice =rowObj.budgprice;//Ԥ�㵥��
		var bsupcon =rowObj.SupCondit;//��������
		var bnum =rowObj.budgnum;//Ԥ������
		var bremar =rowObj.Remarks;//˵��
		var bsum =rowObj.budgvalue;//Ԥ����
		var bbrand1 =rowObj.brand1;//�Ƽ�Ʒ��1
		var bperce =rowObj.budgpro;//Ԥ����ռ��
		var bspec1 =rowObj.spec1;//����ͺ�1
		var bdept =rowObj.deptdr;//Ԥ�����
		var bbrand2 =rowObj.brand2;
		var bae =rowObj.isaddedit;//����/����
		if(bae =="����"){
			bae = 1;
		}else{
			bae = 2;
		};
		var bspec2 =rowObj.spec2;
		var bequremark =rowObj.budgdesc;//�豸���Ʊ�ע
		var bbrand3 =rowObj.brand3;
		var bfeesca =rowObj.FeeScale;//�շѱ�׼
		var bspec3 =rowObj.spec3;
		var bperori =rowObj.PerOrigin;//��Ա���ʡ�ԭ���豸
		
	// Ԥ���Ŀ��������
    var AddItemObj = $HUI.combobox("#BItembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            //param.year 	 = $('#BYMbox').combobox('getValue');
            //param.deptdr = $('#BDutybox').combobox('getValue');
            param.str 	 = param.q;
        },
	});
    // �ʽ����͵�������
    var AddFundTyObj = $HUI.combobox("#BFundTypebox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=FundType",
        mode:'remote',
        valueField:'fundTypeId',    
        textField:'fundTypeNa',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
    });
	
	// Ԥ����ҵ�������
    var AddBgDeptObj = $HUI.combobox("#BDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Deptnamelist",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
	// ����/����
	var BAEboxObj = $HUI.combobox("#BAEbox",{
		mode:'remote',
		valueField:'id',
		textField:'text',
		data:[{id:'1',text:'����'},{id:'2',text:'����'}]
	});
	//Ԥ�㵥�۱仯������Ԥ����
    $('#BPricebox').keyup(function(event){
    	Calcu();
    });
    //Ԥ�������仯������Ԥ����
    $('#BNumbox').numberspinner({
		value:bnum,
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }); 
    //����Ԥ���� = ����*���� 
    function Calcu(){
    	var EditPrice = parseFloat($('#BPricebox').val());  //Ԥ�㵥��
    	if (EditPrice ==""||isNaN(EditPrice)){EditPrice = 0};
    	var EditNum = parseFloat($('#BNumbox').val()); //Ԥ������
    	if (EditNum ==""||isNaN(EditNum)){EditNum = 0};
    	$('#BSumbox').val(EditPrice.toFixed(2)*EditNum.toFixed(0));
    };
		
		$('#BFundTypebox').combobox('setValue',fundtype);
		$('#BAnnBenbox').val(bannben);
		$('#BItembox').combobox('setValue',bitem);
		$('#BMatCharbox').val(bmatchar);
		$('#BPricebox').val(bprice);
		$('#BSupConbox').val(bsupcon);
		$('#BNumbox').val(bnum);
		$('#BRemarkbox').val(bremar);
		$('#BSumbox').val(bsum);
		$('#BBrand1box').val(bbrand1);
		$('#BPercebox').val(bperce);
		$('#BSpec1box').val(bspec1);
		$('#BDeptbox').combobox('setValue',bdept);
		$('#BBrand2box').val(bbrand2);
		$('#BAEbox').combobox('setValue',bae);
		$('#BSpec2box').val(bspec2);
		$('#BEquRemarkbox').val(bequremark);
		$('#BBrand3box').val(bbrand3);
		$('#BFeeScabox').val(bfeesca);
		$('#BSpec3box').val(bspec3);
		$('#BPerOribox').val(bperori);
		//��ӷ��� 
    $("#BtchSave").unbind('click').click(function(){
        var fundtype=$('#BFundTypebox').combobox('getValue');//�ʽ�����
		var bannben=$('#BAnnBenbox').val();//��Ч��Ԥ��
		var bitem=$('#BItembox').combobox('getValue');//Ԥ���Ŀ
		var bmatchar=$('#BMatCharbox').val();//�Ĳķ�
		var bprice =$('#BPricebox').val();//Ԥ�㵥��
		var bsupcon =$('#BSupConbox').val();//��������
		var bnum =$('#BNumbox').val();//Ԥ������
		var bremar =$('#BRemarkbox').val();//˵��
		var bsum =$('#BSumbox').val();//Ԥ����
		var bbrand1 =$('#BBrand1box').val();//�Ƽ�Ʒ��1
		var bperce =$('#BPercebox').val();//Ԥ����ռ��
		var bspec1 =$('#BSpec1box').val();//����ͺ�1
		var bdept =$('#BDeptbox').combobox('getValue');//Ԥ�����
		var bbrand2 =$('#BBrand2box').val();
		var bae =$('#BAEbox').combobox('getValue');//����/����
		var bspec2 =$('#BSpec2box').val();
		var bequremark =$('#BEquRemarkbox').val();//�豸���Ʊ�ע
		var bbrand3 =$('#BBrand3box').val();
		var bfeesca =$('#BFeeScabox').val();//�շѱ�׼
		var bspec3 =$('#BSpec3box').val();
		var bperori =$('#BPerOribox').val();//��Ա���ʡ�ԭ���豸
		
		if(ChkPef()==true){
		//��ȡ��������,����ID,��ȡ������
		var rows = $('#MainGrid').datagrid('getSelections');
		for(var i=0;i<rows.length;i++){
			var year=rows[i]['year'];
            var projadjdr=rows[i]['projadjdr'];	
            var uname=rows[i]['username'];			
		};
		//alert('��ȣ�'+year);
		//alert('����ID��'+projadjdr);
		//alert('���ұ��룺'+itemcode);
        //alert('�ʽ����:'+ fundtype);		
		var datad = projadjdr + '|' + year + '|' + itemcode + '|' + bprice + '|'+ bnum + '|' + bsum + '|' + bequremark + '|' + bfeesca  
		+ '|' + bannben + '|' + bmatchar + '|' + bsupcon + '|' + bremar + '|' + bbrand1 
		+ '|' + bspec1 + '|' + bbrand2 + '|' + bspec2 + '|' + bbrand3 + '|' + bspec3
		+ '|' + bae + '|' + bperori + '|' + userid + '|' + uname + '|' + fundtype 
		+ '|' + bperce + '|' + hospid + '|' + bdept;
		//alert(rowid);
		//alert(datad);
        $.m({
            ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',MethodName:'UpdateDetail',detailrowid:rowid,data:datad},
            function(Data){
                if(Data==0){
                    $.messager.popover({
					msg: "����ɹ���",
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }else{
	                $.messager.popover({
					msg: '������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                }
            }
        );
         $win.window('close');
		}
    });
    $("#BtchClose").unbind('click').click(function(){
        $win.window('close');
    });
		
	}; //�޸ĺ���������

    //����޸İ�ť
	$("#UpdataBn").click(UpdaBtn);
    
    //ɾ��
	var DelBtn=function(){
	
		$.messager.confirm('ȷ��','ȷ��Ҫɾ��ѡ����������',function(t){
           if(t){
			   
			var mainRows = $('#MainGrid').datagrid('getSelections');
			var mainLen = mainRows.length;
			for(var j=0;j<mainLen;j++){
				var uname=mainRows[j]['username'];
			};
			
            var rows = $('#DetailGrid').datagrid('getSelections');
            var len = rows.length;
			for(var i=0;i<rows.length;i++){
				var rowid=rows[i]['rowid'];
				var projadjdr=rows[i]['projadjdr'];
                $.m({
                ClassName:'herp.budg.hisui.udata.uBudgProjEstablish',
				MethodName:'DelDetail',
				userId:userid,
				uname:uname,
				detailrowid:rowid,
				projadjdr:projadjdr,
				hospid:hospid},
                function(Data){
                    if(Data==0){
	                $.messager.popover({
					msg: 'ɾ���ɹ���',
					type: 'success',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
					
				});
                $('#DetailGrid').datagrid("reload")
                    }else{
	                     $.messager.popover({
					msg: 'ɾ��ʧ��! ������Ϣ:' +Data,
					type: 'error',
					style: {
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 10
					}
				});
                $('#DetailGrid').datagrid("reload")
              
                    }
                }
            );
			}; 
           } 
        })  
	 
	}
	
	//���ɾ����ť
	$("#DelBn").click(DelBtn);	
	
    
	
    
}