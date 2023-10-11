/**
 *��ťȨ��˵��
 *�½�״̬�����ӡ����桢ɾ��������
 *��������������
 *
 **/

var RowDelim = String.fromCharCode(1); //�����ݼ�ķָ���, IsCheck, curSchemeName, syear
DetailFun = function (row,comboboxFormatter) {
	//console.log(JSON.stringify(row));
	
	var curSchemeDr = row.rowid;
	var IsCheck = row.IsCheck;
	var curSchemeName = row.Name;
	var year = row.Year;
	var schemdr = row.rowid;
	  
	//��ʼ������
	var $Detailwin;
	$Detailwin = $('#DetailWin').window({
	    title: '��ǰ����:'+curSchemeName,
	    width: 1015,
	    height: 500,
	    top: ($(window).height() - 500) * 0.5,
	    left: ($(window).width() - 1015) * 0.5,
	    shadow: true,
	    modal: true,
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    resizable: true,
	    onClose:function(){ //�رչرմ��ں󴥷�
	    	
            //$("#MainGrid").datagrid("reload"); //�رմ��ڣ����¼��������
        }
	});
	$Detailwin.window('open');
    
    
    //�����ö���
    EditColumns=[[  
                {
	                field:'ck',
	                checkbox:true
	            },{
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'sname',
	                title:'��Ŀ����',
	                width:250,
	                allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'code',
							textField:'name1',
							mode:'remote',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem",
							delay:200,
                    		onBeforeLoad:function(param){
	                    		param.str = param.q;
	                    		param.hospid=hospid;
                                param.year= year; 
	                    	},                           
                    	required:true
                    	}
					}
	            },{
	                field:'CalFlag',
	                title:'���㷽��',
	                width:160,
					formatter:comboboxFormatter,
					allowBlank:false,
	                editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'��ʽ����'},
							{id:'2',name:'��ʷ����* ����ϵ��'},
							{id:'3',name:'��ʷ����'}
							],
		                    onSelect: function(rec){ 
		                    	/*��ʽ����ѡ��󣬵�����ʽ���ô���*/
		                        if(rec.id=='1'){
			                        var rowIndex=getRowIndex(this);
			                        var getRows=$("#DetailGrid").datagrid("getRows");
			                        var OldeFormula=getRows[rowIndex].formuladesc;
		                        	formula(OldeFormula,rowIndex,$("#DetailGrid"),"formuladesc","formulaset");
		                        }; 
		                    }
                    	}
					}
                },{
	                field:'IsCal',
	                title:'�Ƿ����',
	                width:70,
					align:'center',
					allowBlank:false,
					formatter: function (value, rec, rowIndex) {
						if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
	                editor:{type:'icheckbox',options:{on:'1',off:'0',onCheckChange:function(event,value){
		                var rowIndex=getRowIndex(this);
		                var Editors = $('#DetailGrid').datagrid("getEditors",rowIndex);
		                if(value==false){
			                $(Editors[1].target).combobox("disable");
			                $(Editors[1].target).combobox("clear");
			                $(Editors[3].target).text();
			                $(Editors[3].target).attr("disabled",true);
			                $(Editors[4].target).attr("disabled",true);
			            }else{
				            $(Editors[1].target).combobox("enable");
				            $(Editors[3].target).attr("disabled",false);
				            $(Editors[4].target).attr("disabled",false);
				        }
		                }}}
                },{
		            field:'CalNo',
		            title:'����˳��',
		            width:100,
		            editor:{type:'text'}
		        },{
		            field:'formulaset',
		            title:'��ʽ���ʽ',
		            width:180,
		            hidden: true,
		            editor:{type:'text'}

		        },{ 
			        field:'formuladesc',
			        title:'��ʽ����',
			        width:180,
			        editor:{type:'text'}
			    },{
				    field:'IsSplit',
				    title:'�Ƿ�ֽ�',
					align:'center',
				    width:70,
				    allowBlank:false,
					formatter: function (value, rec, rowIndex) {
						if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
	                editor:{type:'checkbox',options:{on:'1',off:'0'}}
				},{
					field:'IsLast',
					title:'�Ƿ�ĩ��',
					width:70,
					align:'center',
					hidden:true,
					editor:{type:'checkbox',options:{on:'1',off:'0'}}
				}

            ]];
    //������ť 
    var BatchBtn={
        id: 'Batchset',
        iconCls: 'icon-batch-cfg',
        text: '����',
        handler: function() {
            batchsetting (year,schemdr);  
        }
    }
    //������Ӱ�ť
    var BatchaddBtn={
        id: 'BatchAdd',
        iconCls: 'icon-batch-add',
        text: '�������',
        handler: function() {
            batchadd (year,schemdr);  
        }
    }
    
    //���Ӱ�ť
    var AddBtn={
        id: 'AddD',
        iconCls: 'icon-add',
        text: '����',
        handler: function(){ 
            append();  //����һ�к���
        }
    }
    //���水ť
    var SaveBtn= {
        id: 'SaveD',
        iconCls: 'icon-save',
        text: '����',
        handler: function(){
	        save(); //���淽��
        }
    }
    //ɾ����ť
    var DelBt= {
        id: 'DelD',
        iconCls: 'icon-cancel',
        text: 'ɾ��',
        handler: function(){
	         if($('#DetailGrid').datagrid("getSelections").length==0){
			               $.messager.popover({
			               msg:'û��ѡ�еļ�¼��',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			          }else{
	        del($('#DetailGrid'),'herp.budg.udata.uBudgSchemDetail','Delete');
		              }}
       
    }
    //���ð�ť
    var ClearBT= {
        id: 'ClearD',
        iconCls: 'icon-reset',
        text: '����',
        handler: function(){
            clear($('#DetailGrid'));
        }
    }
  
    //������
    var DetailGrid = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
            MethodName:"DetailList",
            schemeDr : curSchemeDr 
        },
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        singleSelect: false, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : true,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        loadMsg:"���ڼ��أ����Եȡ�",
        rownumbers:true,//�к� 
        nowap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:EditColumns,
        onClickRow: onClickRow,  //���û����һ�е�ʱ�򴥷�
       /* onClickCell: function(index,field,value){
	        if(field=="formuladesc"){
		        $('#DetailGrid').datagrid('selectRow', index);
		        $('#DetailGrid').datagrid('beginEdit', index);
		        var cellEdit = $('#DetailGrid').datagrid("getEditor",{index:index,field:"formuladesc"});
		        $(cellEdit.target).prop('disabled',true);
		        var oldFormula=$('#DetailGrid').datagrid('getSelected').formuladesc
		        formula(oldFormula,index,$("#DetailGrid"),"formuladesc","formulaset")}},*/
        onBeforeEdit:function(rowIndex, rowData){
            /*if (checkBefEdit() == false) {
                return false;
            } else {
                return true;
            } */           
        },
        toolbar: [BatchaddBtn,BatchBtn,AddBtn,SaveBtn,DelBt,ClearBT]       
    });
	
	if(IsCheck=="���"){
		$('#Batchset').linkbutton('disable');
		$('#BatchAdd').linkbutton('disable');
		$('#AddD').linkbutton('disable');
		$('#SaveD').linkbutton('disable');
		$('#DelD').linkbutton('disable');
		$('#ClearD').linkbutton('disable');
	} 
	
    //������
    var editIndex = undefined; //����ȫ�ֱ�������ǰ�༭����
 	function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#DetailGrid').datagrid('validateRow', editIndex)){
				//�б���������ʵ�֣��޸ĺ�ѻ�дsname����Ϊformatter��ʾ����sname�ֶ�
				//��Ŀ����
				$('#DetailGrid').datagrid('beginEdit', editIndex);
				var ed = $('#DetailGrid').datagrid('getEditor', {index:editIndex,field:'sname'});
				var sname = $(ed.target).combobox('getText');
				$('#DetailGrid').datagrid('getRows')[editIndex]['sname'] = sname;
                $('#DetailGrid').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
	function onClickRow(index,row){
			if (editIndex != index){
				if (endEditing()){
					$('#DetailGrid').datagrid('selectRow', index)
					$('#DetailGrid').datagrid('beginEdit', index);
				var cellEdit = $('#DetailGrid').datagrid("getEditor",{index:index,field:"formuladesc"});
				  
				  $(cellEdit.target).focus(function(){
					  if(row.CalFlag==1){
				      var oldFormula=$('#DetailGrid').datagrid('getSelected').formuladesc
		              formula(oldFormula,index,$("#DetailGrid"),"formuladesc","formulaset")
					  }else{
						$('#DetailGrid').datagrid('endEdit', index);
						$(cellEdit.target).prop('disabled',true) }	
				      })
					editIndex = index;
				} else {
					$('#DetailGrid').datagrid('selectRow', editIndex);
				}
			}
		}
          
    //���ӷ���
    	function append(){
            if (endEditing()){
				$('#DetailGrid').datagrid('appendRow',{CalFlag:2,IsCal:1});
				editIndex = $('#DetailGrid').datagrid('getRows').length-1;
				$('#DetailGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
			}
        }
        /*//ɾ������
    	function del(){
	    	if (editIndex == undefined){return}
			$.messager.confirm('ȷ��','ȷ��Ҫɾ��ѡ����������',function(t){
            if(t){
                var rows = $('#DetailGrid').datagrid("getSelections");
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//��������ɾ��
			              editIndex= $('#DetailGrid').datagrid('getRowIndex', row);
			              $('#DetailGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
			          }else{//����ѡ�е���ɾ��
				          $.m({
					          ClassName:'herp.budg.udata.uBudgSchemDetail',
					          MethodName:'Delete',
					          rowid:rowid
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.alert('��ʾ','ɾ���ɹ���','info',function(){$('#DetailGrid').datagrid("reload")});
							      }else{
								      $.messager.alert('��ʾ','������Ϣ:' +Data,'error',function(){$('#DetailGrid').datagrid("reload")});
								  }
							});
				      }
		            } 
	            }else{return}//û��ѡ�У�������
                               
                $("#DetailGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                editIndex = undefined;
            } 
        	}) 
    	}*/
    	function save(){
	    	if($('#DetailGrid').datagrid("getSelections").length==0){
			$.messager.popover({
			               msg:'û��ѡ�еļ�¼��',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
			$.messager.confirm('ȷ��','ȷ��Ҫ����ѡ����������',function(t){
            if(t){
	            // �ر����һ����ǰ�༭�У��������һ�е����ݲ��ᱻgetChanges��������
	            $('#DetailGrid').datagrid('endEdit', editIndex);
	            var rows = $('#DetailGrid').datagrid("getChanges");
	            var rowIndex="";
                if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		                var row=rows[i];
		                var rowid= row.rowid;
		                
		                //����ǰ����Ϊ���е���֤
		                if (saveAllowBlankVaild($('#DetailGrid'),row)){
		              
		              //console.log(JSON.stringify(row));
		              //console.log(row.sname);
		              var sname=((row.sname=="undefined")?'':row.sname.split("_")[0]);
		              var CalFlag=((row.CalFlag=="undefined")?'':row.CalFlag);
		              var IsCal=((row.IsCal=="undefined")?'':row.IsCal);
		              var formulaset=((row.formulaset=="undefined")?'':row.formulaset);
		              var formuladesc=((row.formuladesc=="undefined")?'':row.formuladesc);
		              var IsSplit=((row.IsSplit=="undefined")?'':row.IsSplit);
		              var SplitMeth=((row.SplitMeth=="undefined")?'':row.SplitMeth);
		              var CalNo=((row.CalNo=="undefined")?'':row.CalNo);
		         
		              
		              //SchemDR, Code, Level, CalFlag, IsCal, Formula, CalNo, formuladesc, IsSplit, SplitMeth
		              //sname,CalFlag,IsCal,set,formulaset,formuladesc,IsSplit,SplitMeth
		              // ��̨��������ʱ����ʾһ����ʾ�򣬷�ֹ�û���ε�������桿�ظ��ύ����
                      $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  });
		              if(!row.rowid){//�������б���
			              $.m({
					          ClassName:'herp.budg.udata.uBudgSchemDetail',
					          MethodName:'Insert',
					          SchemDR:curSchemeDr,
					          Code:sname,
					          Level:'',
					          CalFlag:CalFlag,
					          IsCal:IsCal,
					          Formula:formulaset,
					          CalNo:CalNo,
					          CalDesc:formuladesc,
					          IsSplit:IsSplit,
					          SplitMeth:SplitMeth
					          },
					          function(Data){
						          if(Data==0){
							         $.messager.popover({
								          msg: '����ɹ���',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  $('#DetailGrid').datagrid("reload");
							       	  editIndex = undefined;
							      }else{
								      var message=""
								       if (Data=="RepName"){
									       $.messager.popover({
										        msg: '�����ظ�',
										        type:'error',
										        style:{"position":"absolute","z-index":"9999",
										        left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}
										         else{
											         $.messager.popover({
												          msg: '����ʧ��'+Data,
												          type:'error',
												          style:{"position":"absolute","z-index":"9999",
												          left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}}		  
							 $.messager.progress('close');
							});
			          }else{//�������޸�
				          $.m({
					          ClassName:'herp.budg.udata.uBudgSchemDetail',
					          MethodName:'Update',
					          rowid:rowid,
					          SchemDR:curSchemeDr,
					          Code:sname,
					          Level:'',
					          CalFlag:CalFlag,
					          IsCal:'',
					          Formula:formulaset,
					          CalNo:CalNo,
					          CalDesc:formuladesc,
					          IsSplit:IsSplit,
					          SplitMeth:SplitMeth
					          },
					          function(SQLCODE){
						          if(SQLCODE==0){
							          $.messager.popover({
								          msg: '����ɹ���',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
							      	  $.messager.progress('close');
							      	  $('#DetailGrid').datagrid("reload");
							      	  editIndex = undefined;
							      }else{
								      var message=""
								       if (SQLCODE=="RepName"){
									       $.messager.popover({
										        msg: '�����ظ�',
										        type:'error',
										        style:{"position":"absolute","z-index":"9999",
										        left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}
										         else{
											         $.messager.popover({
												          msg: '����ʧ��'+SQLCODE,
												          type:'error',
												          style:{"position":"absolute","z-index":"9999",
												          left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}}		  
							 $.messager.progress('close');		  
							});
				      }
	                }
		            } 
	                
	            }else{return}//û�иı䣬������
                editIndex = undefined;               
                $("#DetailGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                
            }
			})
	    }
    //�رհ�ť
	$("#DetailClose").click(function(){
        $Detailwin.window('close');
    })
}