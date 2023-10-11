/*
csp: herp.budg.hisui.budgschemmain.csp
*/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//��ʼ��
    Init();
}); 

function Init(){
	//Ԥ�����combox
    var YearboxObj = $HUI.combobox("#Yearbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
                
	// �������combox 
    var SchemTypeboxObj = $HUI.combobox("#SchemTypebox",{
        valueField:'id',
		textField:'name',
		data:[
			{id:'1',name:'ȫԺ'}
			,{id:'2',name:'����'}	
		]
    });
    
     //��ѯ����
     $("#FindBn").click(function(){
        var year		= $('#Yearbox').combobox('getValue'); // Ԥ�����
        var schemtype	= $('#SchemTypebox').combobox('getValue'); // ���ݵ���
        var schem		= $('#Schemfeild').val(); // ������

        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
                MethodName:"List",
                hospid : hospid,
                Year : year,
                sChemeType :schemtype,
                sCN : schem
            })
    })

    MainColumns=[[  
                {
	                field:'ck',
	                checkbox:true
	            },{
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
                },{
	                field:'CompName',
	                title:'ҽ�Ƶ�λ',
	                width:80,
	                hidden: true
	            },{
	                field:'Year',
	                allowBlank:false,
	                title:'���',
	                width:70,
	                //allowBlank:false,
					editor:{
						type:'combobox',
						options:{
							valueField:'year',
							textField:'year',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
							delay:200,
                    		onBeforeLoad:function(param){
	                    		param.str = param.q;
	                    	},  
	                    	onSelect:function(data){
		                    	var value = data.year;
		                    	var row = $('#MainGrid').datagrid('getSelected');  
                                var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);//��ȡ�к�  
                                //var thisTarget = $('#MainGrid').datagrid('getEditor', {'index':rowIndex,'field':'Year'}).target;  
                                //var value = thisTarget.combobox('getValue'); 
                                        
		                    	var target = $('#MainGrid').datagrid('getEditor', {'index':rowIndex,'field':'ItemCode'}).target;  
                                target.combobox('clear'); //���ԭ��������  
                                var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem&hospid="+hospid+"&year="+value;  
                                target.combobox('reload', url);//���������б�����  
                            },                          
                    	required:true
                    	}
					}
                },{
	                field:'Code',
	                title:'��������',
	                width:90,
	                allowBlank:false,
		            required:true,
	                editor:{
		                type:'validatebox',
		                options:{
			               required:true}
	                }
                },{
	                field:'Name',
	                title:'��������',
		            required:true,
	                width:220,
	                allowBlank:false,
	                editor:{type:'validatebox',
	                 options:{
			              required:true}}
	            },{
		            field:'UnitType',
		            title:'��������',
		            width:80,
	                //allowBlank:false,
					formatter:comboboxFormatter,
	                editor:{
		                type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'ȫԺ'},
							{id:'2',name:'����'}],
							required:true
                    	}
					}
		        },{ 
			        field:'Type',
			        title:'Ԥ�����',
			        width:90,
					formatter:comboboxFormatter,
	                allowBlank:false,
	                editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'name',
							data:[
							{id:'1',name:'�ƻ�ָ��'},
							{id:'2',name:'��֧Ԥ��'},
							{id:'3',name:'���ñ�׼'},
							{id:'4',name:'Ԥ������'}
							],                            
                    	required:true
                    	}
					}
			    },{
				    field:'OrderBy',
				    title:'����˳��',
				    width:80,
				    hidden: true,
	                editor:{type:'text'}
				},{
					field:'ItemCode',
					title:'���Ԥ����',
					//allowBlank:false,
					width:100,
					formatter:function(value,row){
						return row.ItemName;
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'code',
							textField:'name',
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem",
							delay:200,
							required:true,
                    		onBeforeLoad:function(param){
	                    		param.str = param.q;
	                    		param.hospid=hospid;
	                    		var row = $('#MainGrid').datagrid('getSelected');  
                                /*var rowIndex = $('#MainGrid').datagrid('getRowIndex',row);//��ȡ�к�                                 
                                var thisTarget = $('#MainGrid').datagrid('getEditor', {'index':rowIndex,'field':'Year'}).target; 
                                var value = thisTarget.combobox('getValue');*/
                                param.year= row.Year; 
	                    	}
                    	}
					}
				},{
					field:'qzfa',
					title:'ǰ�÷���',
					align:'center',
					width:70,
					hidden:true,
                    formatter:function(value,row,index){
	                    var rowid=row.rowid;
	                    return '<a href="#" class="grid-td-text" onclick=endEditing('+rowid+'\')>����</a>';
                    }
				},{
					field:'nrsz',
					title:'��������',
					align:'center',
					width:70,
                    formatter:function(value,row,index){
	                    return '<span class="grid-td-text"><u>�༭</u></span>'
                    }
				},{
					field:'copy',
					title:'���ݸ���',
					align:'center',
					width:70,
                    formatter:function(value,row,index){
	                    var rowid=row.rowid;
	                    return "<a href='#' class='grid-td-text' onclick=copyfun("+rowid+"\)>����</a>";
                    }
				},{
					field:'IsHelpEdit',
					title:'�Ƿ����',
					width:70,
					align:'center',
					formatter: function (value, rec, rowIndex) {
						if(value==1){
							return '<input type="checkbox" checked="checked" value="' + value + '"/>';
						}else{
							return '<input type="checkbox" value=""/>';
						}
                        
                    },
					editor:{type:'checkbox',options:{on:'1',off:'0'}}
				},{
					field:'IsCheck',
					title:'���״̬',
					width:70
				},{
					field:'chkrowid',
					title:'������',
					width:150,
					//allowBlank:false,
					formatter:function(value,row){
						return row.ChkFlowName;
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'rowid',
							textField:'name', 
							url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Getcheckflow",
							delay:200,
							required:true,
                    		onBeforeLoad:function(param){
	                    		param.hospid = hospid;
	                    		param.str = param.q;
	                    	}
                    	}
					}
				}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
            MethodName:"List",
            hospid :    hospid,
            Year : "",
            sChemeType : "",
            sCN : ""
        },
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: true, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : false,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        nowap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //���û����һ�е�ʱ�򴥷�
        onClickCell: function(index,field,value){   //���û����һ����Ԫ���ʱ�򴥷�
            if (field=="nrsz") {
	            var rows = $('#MainGrid').datagrid('getRows');
	            var row = rows[index];	            
                DetailFun(row,comboboxFormatter);
	             
            }
        },
        toolbar: [
        	{
	        	id: 'Add',
            	iconCls: 'icon-add',
           		text: '����',
            	handler: function(){
	            	add()
           		}
        	},{
	        	id: 'Save',
	        	iconCls: 'icon-save',
	        	text: '����',
	        	handler: function(){
		        	$('#MainGrid').datagrid('endEdit', editIndex);
		        	savefunction()
            	}
        	},{
	        	id: 'Del',
	        	iconCls: 'icon-cancel',
	        	text: 'ɾ��',
	        	handler: function(){
		        	$('#MainGrid').datagrid('endEdit', editIndex);
		        	if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			               $.messager.popover({
			               msg:'û��ѡ�еļ�¼��',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			         }else{
		        	 	del()
		        	 }
		        	
		        }
        	},{
	        	id: 'Clear',
	        	iconCls: 'icon-reset',
	        	text: '����',
	        	handler: function(){
		        	 editIndex=clear($('#MainGrid'))
		        }
        	},{
	        	id: 'Audit',
	        	iconCls: 'icon-stamp',
	        	text: '���',
	        	handler: function(){
		        	audit()
		        }
        	},{
	        	id: 'AuditCancel',
	        	iconCls: 'icon-stamp-cancel',
	        	text: 'ȡ�����',
	        	handler: function(){
		        	auditCancel()
		        }
        	}
        ]      
    });    

  		var editIndex = undefined;
  		var curTr;
  		var curTd;
  		var change;
  		
  		//combox����value��ѡ����ȷ��textFieldֵ,�ʺ�comboxֵ�Ƚ��ٵ����
  		function  comboboxFormatter (value, row, rowIndex){
	  		if (!value){
		  		return value;
		  	}
		  	var e = this.editor;
		  	if(e && e.options && e.options.data){
			  	var values = e.options.data;
			  	for (var i = values.length - 1; i >= 0; i--) {
				  	//0 {k: "1", v: "test"}
				  	var k = values[i]['id'];
				  	if (value == k ){
					  	//����Vֵ
					  	return values[i]['name'];
					}
					// ����float�����ֶΣ�ת������ȡ�����ٱȽ�
					else if (!isNaN(k) && !isNaN(value) && Math.floor(parseFloat(k))===Math.floor(parseFloat(value)) ) {
						return values[i]['id'];
					}
				}
			}
		}               
		function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#MainGrid').datagrid('validateRow', editIndex)){
				//$('#MainGrid').datagrid('beginEdit', editIndex);//��ֹ���֮��ˢ�£�Ȼ���ٵ��
				var row = $('#MainGrid').datagrid('getRows')[editIndex];
				if(row.Code.substring(0,3)!="SYS"){
					
					//�б���������ʵ�֣��޸ĺ�ѻ�дchkname����Ϊformatter��ʾ����chkname�ֶ�
					//������
					$('#MainGrid').datagrid('beginEdit', editIndex);
					var ed = $('#MainGrid').datagrid('getEditor', {index:editIndex,field:'chkrowid'});
					var chkname = $(ed.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[editIndex]['ChkFlowName'] = chkname;
				
					//���Ԥ����
					ed1 = $('#MainGrid').datagrid('getEditor', {index:editIndex,field:'ItemCode'});
					var ItemName = $(ed1.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[editIndex]['ItemName'] = ItemName;
				}
				
                $('#MainGrid').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				//��Ӹ�����ʽ
				//if (curTr) curTr.addClass('edited');
				//curTr = null;
				return true;
			} else {
				return false;
			}
		}
		
		function onClickRow(index){	
			//if (editIndex != index){
				if (endEditing()){
					$('#MainGrid').datagrid('selectRow', index)
						.datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#MainGrid').datagrid('selectRow', editIndex);
				};
				
				var row = $('#MainGrid').datagrid('getRows')[index];
				if(row.Code.substring(0,3)=="SYS"){
					var ed1 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'chkrowid' });
					$(ed1.target).combobox("disable");
					var ed2 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'UnitType' });
					$(ed2.target).combobox("disable");
					var ed3 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'ItemCode' });
					$(ed3.target).combobox("disable");
				}else{
					var ed1 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'chkrowid' });
					$(ed1.target).combobox("enable");
					var ed2 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'UnitType' });
					$(ed2.target).combobox("enable");
					var ed3 = $('#MainGrid').datagrid('getEditor', { index: editIndex, field: 'ItemCode' });
					$(ed3.target).combobox("enable");
				}
			//}
		};
		
		function add(){
			if (endEditing()){
				$('#MainGrid').datagrid('appendRow',{IsCheck:'δ���'});
				editIndex = $('#MainGrid').datagrid('getRows').length-1;
				$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
				//console.log("editIndex:"+editIndex);
				var ed = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'Code' });
			 	$(ed.target).keyup(function (event) {
					if($(ed.target).val().trim().substring(0,3)=="SYS"){
						var ed1 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'chkrowid' });
						$(ed1.target).combobox("disable");
						var ed2 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'UnitType' });
						$(ed2.target).combobox("disable");
						var ed3 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'ItemCode' });
						$(ed3.target).combobox("disable");
					}else{
						var ed1 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'chkrowid' });
						$(ed1.target).combobox("enable");
						var ed2 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'UnitType' });
						$(ed2.target).combobox("enable");
						var ed3 = $('#MainGrid').datagrid('getEditor', { 'index': editIndex, field: 'ItemCode' });
						$(ed3.target).combobox("enable");
					}
			 })	
			}
		}
		function del(){
			$.messager.confirm('ȷ��','ȷ��Ҫɾ��ѡ����������',function(t){
            if(t){
                var rows1 = $('#MainGrid').datagrid("getSelections");
                var rows2 = $('#MainGrid').datagrid("getChecked")
                var c = rows1.concat(rows2);//�ϲ���һ������
                temp = {};//����id�ж��ظ�
                rows = [];//����������
                //����c���飬��ÿ��item.id��temp���Ƿ����ֵ���жϣ��粻�������Ӧ��item��ֵ�������飬����temp��item.id��Ӧ��key��ֵ���´ζ���ֵͬ���ж�ʱ�㲻���ߴ˷�֧���ﵽ�ж��ظ�ֵ��Ŀ�ģ�
                c.map(function(item,indexx){
	                if(!temp[item.rowid]){
		                rows.push(item);
		                temp[item.rowid] = true;
		            }
		        });
		        //console.log(JSON.stringify(rows));
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//��������ɾ��
			              editIndex= $('#MainGrid').datagrid('getRowIndex', row);
			              $('#MainGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
			         }else{//����ѡ�е���ɾ����ֻ�з����״̬�ķ�����ɾ��
			          	if(row.IsCheck!="���"){
				          $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
					          MethodName:'DeleteSM',
					          rowid:rowid
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.popover({
								          msg: 'ɾ���ɹ�',
								          type:'success',
								          style:{"position":"absolute","z-index":"9999",
								          left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
								      $('#MainGrid').datagrid("reload");
							      }else{
								      $.messager.popover({
									      msg: 'ɾ��ʧ�ܣ�',
									      type:'error',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
								  }
							});
			         	}else{
				         	$.messager.popover({
								          msg: '��'+(editIndex+1)+'��,����˲���ɾ����',
								          type:'error',
								          style:{"position":"absolute","z-index":"9999",
								          left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
				         }
				      }
		            } 
	            }else{return}//û��ѡ�У�������
                               
                $('#MainGrid').datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                editIndex = undefined;
                return editIndex;
            } 
        	}) 
    	}
    	function savefunction(){
	    	if($('#MainGrid').datagrid("getChanges").length==0){
			$.messager.popover({
			               msg:'û����Ҫ����ļ�¼��',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
	    	$.messager.confirm('ȷ��','ȷ��Ҫ����ѡ����������',function(t){
		    	if(t){
	            var rows = $('#MainGrid').datagrid("getChanges");
                if(rows.length>0){
	                for(var i=0; i<rows.length; i++){
		                var row=rows[i]; 
		                //console.log("row:"+JSON.stringify(row));
		                var rowid= row.rowid;
		                if(row.Code){
			                if(row.Code.substring(0,3)!="SYS"){
				                if(!row.UnitType){
					                $.messager.popover({
						                msg: '�������Բ���Ϊ��',
						                type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                left:-document.body.scrollTop - document.documentElement.scrollTop/2}
						        	})
						        	return;
						        }
						        if(!row.ItemCode){
					                $.messager.popover({
						                msg: '���Ԥ�����Ϊ��',
						                type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                left:-document.body.scrollTop - document.documentElement.scrollTop/2}
						        	})
						        	return;
						        }
						        if(!row.chkrowid){
					                $.messager.popover({
						                msg: '����������Ϊ��',
						                type:'error',
						                style:{"position":"absolute","z-index":"9999",
						                left:-document.body.scrollTop - document.documentElement.scrollTop/2}
						        	})
						        	return;
						        }
				                
				            }
			                
			            }
		              //����ǰ����Ϊ���е���֤
		             if (saveAllowBlankVaild($('#MainGrid'),row)){
			             
		              var Year=((row.Year==undefined)?'':row.Year);
		              var Code=((row.Code==undefined)?'':row.Code);
		              var Name=((row.Name==undefined)?'':row.Name);
		              var Type=((row.Type==undefined)?'':row.Type);
		              var UnitType=((row.UnitType==undefined)?'':row.UnitType);
		              var OrderBy=((row.OrderBy==undefined)?'':row.OrderBy);
		              var ItemCode=((row.ItemCode==undefined)?'':row.ItemCode);
		              var IsCheck='';
		              var CheckDate=((row.CheckDate==undefined)?'':row.CheckDate);;
		              var Checker='';
		              var File='';
		              var IsHelpEdit=((row.IsHelpEdit==undefined)?'':row.IsHelpEdit);
		              var chkrowid=((row.chkrowid==undefined)?'':row.chkrowid);
		              var IsSys='';
		              var CompName=((hospid==undefined)?'':hospid);
		              //2017|11|11|1|1||0|||undefined|undefined|0|1|undefined|2
		              //console.log("CheckDate:"+CheckDate);
		              var data=Year+"|"+Code+"|"+Name+"|"+Type+"|"+UnitType
		              			+"|"+OrderBy+"|"+ItemCode+"|"+IsCheck+"|"+CheckDate
		              			+"|"+Checker+"|"+File+"|"+IsHelpEdit+"|"+chkrowid
		              			+"|"+IsSys+"|"+CompName;
		              //alert(data);
		              // ��̨��������ʱ����ʾһ����ʾ�򣬷�ֹ�û���ε�������桿�ظ��ύ����
                      $.messager.progress({
	                      title: '��ʾ',
	                      msg: '���ڱ��棬���Ժ򡭡�'
	                  });
		              if(!row.rowid){//�������б���
			              $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
					          MethodName:'InsertSM',
					          data:data
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
							      	  $('#MainGrid').datagrid("reload");
							      	  editIndex = undefined;
							      }else{
								      var message=""
								       if (Data=="RepName"){
									       $.messager.popover({
										        msg: '�����ظ�',
										        type:'error',
										        style:{"position":"absolute","z-index":"9999",
										        left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
										}else{
											$.messager.popover({
												msg: '����ʧ��'+Data,
												type:'error',
												style:{"position":"absolute","z-index":"9999",
												left:-document.body.scrollTop - document.documentElement.scrollTop/2,
												top:1}
												})
										    $.messager.progress('close');
								}}});
			          }else{//�������޸�
				          $.m({
					          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
					          MethodName:'UpdateSM',
					          rowid:rowid,
					          data:data
					          },
					          function(Data){
						          if(Data==0){
							          $.messager.popover({
								          msg: '����ɹ���',
								          type:'success',
								           style:{"position":"absolute","z-index":"9999",
								                 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                                         top:1}});
		                              $('#MainGrid').datagrid("reload");
							      	  $.messager.progress('close');
							      }else{
								      var message=""
								       if (Data=="RepName"){
									       $.messager.popover({
										       msg: '�����ظ�',
										       type:'error',
										       style:{"position":"absolute","z-index":"9999",
										       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										       top:1}})
									   }else{
										   $.messager.popover({
											   msg: '����ʧ��'+Data,
											   type:'error',
											   style:{"position":"absolute","z-index":"9999",
											   left:-document.body.scrollTop - document.documentElement.scrollTop/2,
											   top:1}})}
										   $.messager.progress('close');
								  }
							});
				      }
				      editIndex = undefined;               
                $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
	              }} 
	                
	            }else{return}//û�иı䣬������     
		    	}})
            }
			
	    };
	//���
	function audit(){
		if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			$.messager.popover({
			               msg:'û��ѡ�еļ�¼��',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
			$.messager.confirm('ȷ��','ȷ��Ҫ���ѡ����������',function(t){
            if(t){
                var rows = GetSelectRows($('#MainGrid'));
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//�����������
		               $.messager.popover({
			               msg:'���ȱ�������ˣ�',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			          }else{
				          //����ѡ�е�����ˣ�ֻ���δ��˵�������Ҫ���
				          //console.log(row.IsCheck);
				          if(row.IsCheck=="δ���"){
					          $.m({
						          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
						          MethodName:'Updstate',
						          schMainDr:rowid,
						          Checker:userid
						          },
						          function(Data){
							          if(Data==0){
								      $.messager.popover({
									      msg: '��˳ɹ���',
									      type:'success',
									      style:{"position":"absolute","z-index":"9999",
									      left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									      top:1}});
								          $('#MainGrid').datagrid("reload");
								      }else{
									      $.messager.popover({
										  msg: '�����Ϣ:'+Data,
										  type:'error',
										  style:{"position":"absolute","z-index":"9999",
										  left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										  top:1}});
										  $('#MainGrid').datagrid("reload")
										   }
								});
							}
				      }
		            } 
	            }else{return}//û��ѡ�У�������
                               
                $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                editIndex = undefined;
            } 
        	}) 
	};
	
	//ȡ�����
	function auditCancel(){
		if($('#MainGrid').datagrid("getSelections").length==0&&($('#MainGrid').datagrid("getChecked").length==0)){
			$.messager.popover({
			               msg:'û��ѡ�еļ�¼��',
			               timeout: 2000,type:'alert',
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2}})
			              return;
			}
			$.messager.confirm('ȷ��','ȷ��Ҫȡ�����ѡ����������',function(t){
            if(t){
                var rows =GetSelectRows($('#MainGrid'));
                //console.log(JSON.stringify(rows));
                //console.log(rows.length);
                if(rows.length>0){
	                //alert(rows.length);
	                for(var i=0; i<rows.length; i++){
		              var row=rows[i];
		              var rowid= row.rowid;
		              if(!(row.rowid>0)){//��������ȡ�����
		                $.messager.popover({
			               msg:'δ��ˣ�����ȡ����ˣ�',
			               type:'alert',
			               timeout: 2000,
			               showType: 'show',
			               style:{"position":"absolute","z-index":"9999",
			               left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			               top:1}});
                            return;
			          }else{
				          //����ѡ�е�����ˣ�ֻ�����˵�������Ҫȡ�����
				          //console.log(row.IsCheck);
				          if(row.IsCheck=="���"){
					          $.m({
						          ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
						          MethodName:'UnUpdstate',
						          schMainDr:rowid,
						          Checker:userid
						          },
						          function(Data){
							          if(Data==0){
								           $.messager.popover({
									           msg: 'ȡ����˳ɹ���',
									           type:'success',
									           style:{"position":"absolute","z-index":"9999",
									           left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									           top:1}});
									        $('#MainGrid').datagrid("reload")
								      }else{
									       $.messager.popover({
										       msg: '����ʧ��:'+Data,
										       type:'error',
										       style:{"position":"absolute","z-index":"9999",
										       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
										       top:1}});
									  }
								});
							}
				      }
		            } 
	            }else{return}//û��ѡ�У�������
                               
                $("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                editIndex = undefined;
            } 
        	}) 
	};
	//����
	copyfun=function (rowid){
		//console.log(rowid);
		if(!(rowid>0)){//�������и���
		$.messager.popover({
			msg:'���ȱ����ٸ��ƣ�',
			type:'alert',
			timeout: 2000,
			showType: 'show',
			style:{"position":"absolute","z-index":"9999",
			left:-document.body.scrollTop - document.documentElement.scrollTop/2,
			top:1}});
		     return;
		 }else{
			 $.messager.prompt("����", "���Ƶ����:", function (r) {
				 if (r) {
					 $.m({
						 ClassName:'herp.budg.hisui.udata.uBudgSchemMain',
						 MethodName:'copyScheme',
						 schemeDr:rowid,
						 Year:r
						 },
						 function(Data){
							 if(Data==0){
								 $.messager.popover({
									 msg: '���Ƴɹ���',
									 type:'success',
									 style:{"position":"absolute","z-index":"9999",
									 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									 top:1}});
									 $('#MainGrid').datagrid("reload")
									 }else{
								 $.messager.popover({
									 msg: '����ʧ��:'+Data,
									 type:'error',
									 style:{"position":"absolute","z-index":"9999",
									 left:-document.body.scrollTop - document.documentElement.scrollTop/2,
									 top:1}});
							 	}
							 });
				} else {
					return
					}
					});	
				}
				$("#MainGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
                editIndex = undefined;
	};
   //����������ı���
   var Code1 = $('#Code').attr('getValue'); 
   $("#Code").blur(function(){
		    if("Code1".substring(0, 3) == "SYS"){
			    $("#UnitType").combobox("disable");
			    $("#Type").combobox("disable");
			    $("#chkrowid").combobox("disable")}} 
    )