/*
* ҩѧ�鷿
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
if ("undefined"!==typeof(websys_getMWToken)){
	url += "?MWToken="+websys_getMWToken()
	}
var titleNotes='<span style="font-weight:bold;">'+$g("�ص��עҩ��")+'</span>';
var titleNote='<span style="font-weight:bold;">'+$g("��Ժ��ҩ�б�")+'</span>';
var EpisodeID=""
var tmp=""; 			/// ������ÿ���ּ��˵�����ʾ����ʱ��ȡ���Ĳ��˻�����Ϣ
$(document).ready(function(){	

	EpisodeID=getParam("EpisodeID")		/// Ĭ�ϴ�����Ժ���߽��� qunianpeng 2018/3/10
	PatientID=getParam("PatientID")
 	choseMenu($g("����Ժ����"));
	$('.easyui-accordion ul li a:contains('+$g("����Ժ����")+')').css({"background":"#87CEFA"});	
	
	//���ݵ����ϸ��ʾ����panel
	$('.easyui-accordion ul li a').click(function(){
		$('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		$(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //�����˵�����ʾ��Ӧ����
		 choseMenu(panelTitle);
	});
	InitPageComInfo(EpisodeID); 		/// ��ʼ��ҳ���������
	InitGuiScopeTable();        		/// ��ʼ��ָ����Χ  add by yuliping
	pageBasicControll();
	InitPageData();
	//getPatFirProNote(EpisodeID);  	/// ���ò��˲��̼�¼��Ϣ
	
})

function choseMenu(item){
	switch(item){
		case $g("����Ժ����"):
			//��ֹ�ظ����������ʱFlag=1�����²�ִ�д�������
			if(Flag1==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��$g("����Ժ����")��panel
				createPanel();
				//����mainPanel�ɼ�
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>"+$g('[��ɫ*�ű�ע��Ϊ������]')+"</span>"
				});
				$('input[name="ordFiter"][value=""]').attr("checked", true);
			}			
			break;
			
		case $g("סԺ�ڼ仼��"):
			if(Flag2==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��$g("סԺ�ڼ仼��")��panel
				createInHopPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>"+$g('[��ɫ*�ű�ע��Ϊ������]')+"</span>"
				});
				//��������
				//loadData();
				$('input[name="ordFiter"][value=""]').attr("checked", true);
			}
			break;			
		case $g("��Ժ����"):
			if(Flag3==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��$g("סԺ�ڼ仼��")��panel
				createOutHopPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>"+$g('[��ɫ*�ű�ע��Ϊ������]')+"</span>"
				});
				//��������
				//loadData();
				$('input[name="ordFiter"][value="OUT"]').attr("checked", true);
			}
			break;			
		default:
			break;	
	}
				 	
} 


//--����$g("����Ժ����")������--//
var Flag1=0;//��ֹ�ظ��������δ������
function createPanel() {
	if(Flag1==0){
		//����ʾ��ѯ������
		$("#content1").css("display","block");
		Flag1=1;
		Flag2=0;
		Flag3=0;
		InitPatientInfo(EpisodeID);		
	}
} 

//���ر���Ĭ����Ϣ
function InitPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   //��ȡ���˻�����Ϣ
  $.ajax({type: "POST", url: url, data: "action=GetPatInfo&AdmDr="+EpisodeID,
	   success: function(val){
			tmp=val.split("^");
			//������Ϣ		
			$('#InHosdiag').val(tmp[8])  	/// ��Ժ���     nisijia 2016-09-19			
	   }
   })
   
   //�������ҳ���ϵ�checkbox��ѡ��״̬
   /*$("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
   });*/
   
   var wardRoundID="";
   
   //��ȡ����Ժ���߲鷿��¼��Ϣ
   $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getPatWardInf&AdmDr="+EpisodeID+"&Status="+"New",
       dataType: "json",
       success: function(Data){
		 if(Data.RowId==""){						///û�в鷿��¼��������������Ϣ�ӵ��Ӳ�����ȡ  qunianpeng 2018/3/13
				$('#PreDisHis').val(Data.CurrentMed);			/// �ֲ�ʷ
			  	$('#PasDisHis').val(Data.PastHistory);			/// ������ʷ
			  	$('#PasMedHis').val(Data.patPMDrgHisDesc);			/// ������ҩʷ
			  	$('#PerAndFamHis').val(Data.Personal);		/// ����ʷ������ʷ
		        $('#DisAndTre').val(Data.Family);			/// �鷢��������ҩ���
		      	$('#AllergicHis').val(Data.Allergy); 		/// ����ʷ	      		      	
		   }
	      else{
		  	$('#RowId').val(Data.RowId);				/// ��ID		  	
		  	$('#patBloodType').val(Data.WRBloodType);	/// Ѫ��
		  	$('#InHosdiag').val(Data.WRICDesc);		/// ���            
		  	$('#PreDisHis').val(Data.wrHisPreComList);			/// �ֲ�ʷ
		  	$('#PasDisHis').val(Data.wrPasDisHisList);			/// ������ʷ
		  	$('#PasMedHis').val(Data.wrPasMedHisList);			/// ������ҩʷ
		  	$('#PerAndFamHis').val(Data.wrPerFamHisList);		/// ����ʷ������ʷ
	      	$('#DisAndTre').val(Data.wrConDisTreList);			/// �鷢��������ҩ���
	      	$('#AllergicHis').val(Data.wrAllergHisList); 		/// ����ʷ
	      	$('#NewInPatGuideContent').val(Data.WRGuidance);		/// ָ�����
	      	$('#patWeight').val(Data.PatW);
		  

	         var maxlimit=800;
	      	  if ($('#NewInPatGuideContent').val().length >maxlimit){  
                   $('#NewInPatGuideContent').val(($('#NewInPatGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen"]').val(maxlimit-$('#NewInPatGuideContent').val().length);
		       }
	      	//���ù�ѡ���ѡ��״̬
	      	var checkList=Data.wrGuidanceList.substring(0,Data.wrGuidanceList.length).split("^");
	      	$("input[type='checkbox']").each(function(){
		       for(var i=0;i<checkList.length;i++){
		          /*if($(this).val()==checkList[i]&$(this).val()==1){
			           	//���value=1����������Ŀ������1.��ѡ��ǰ��2.������Ŀ��ʾ
			       		$(this).attr("checked",true);
			       		$(this).parent().parent().next().css("display","block");	
			       }else if($(this).val()==checkList[i]&$(this).val()!=1){
				        //���value!=1����������Ŀ����ֻ�蹴ѡ��ǰ��
				   		$(this).attr("checked",true);
				   }*/
				   if($(this).val()==checkList[i]){
				   $(this).attr("checked",true);
			       $(this).parent().parent().next().css("display","block");	
				   }
		       }
		  	});
		  	$('#otherGuiscopeN').val(Data.wrGuidanceOther);  	///����  2017-09-13 yuliping
		  	
		  	//��ȡ�鷿��¼ID�����id�����ڣ����޲鷿��¼���򲻼���ҩƷ��Ϣ�б�
		  	wardRoundID=$('#RowId').val();
			if(wardRoundID!=""){
				$.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				$('#drugdg').datagrid('loadData',obj);
       				}
				})
			 } 				
          }
       }       
    });     
}

//--����סԺ�ڼ仼��������--//
var Flag2=0;//��ֹ�ظ��������δ������
function createInHopPanel(){
	if(Flag2==0){
		//����ʾ��ѯ������
		$("#content2").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		//���ز��˻�����Ϣ����������Ϣʱ����ȡ��
		/*
		$.ajax({
   			type: "POST",
   			url: url,
   			data: "action=getAdrRepPatInfo&AdmDr="+EpisodeID+"&LocID="+"",
   			//dataType: "json",
   			success: function(val){
				tmp=val.split("^");

   			}
    	});
    	*/
    	//�������ҳ���ϵ�checkbox��ѡ��״̬
    	/*$("input[type='checkbox']").each(function(){
	    	$(this).attr("checked",false);
	    });*/
	}
}

//--������Ժ����������--//
var Flag3=0;//��ֹ�ظ��������δ������
function createOutHopPanel(){
	if(Flag3==0){
		//����ʾ��ѯ������
		$("#content3").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		InitOutPatientInfo(EpisodeID);			
	}
}

//���س�Ժ���˱���Ĭ����Ϣ
function InitOutPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   //���ز��˻�����Ϣ����������Ϣʱ����ȡ��
   /*
   $.ajax({
   	  type: "POST",
   	  url: url,
   	  data: "action=GetPatEssInfo&AdmDr="+EpisodeID+"&LocID="+"",
   	  //dataType: "json",
   	  success: function(val){
		  tmp=val.split("^");

   	  }
    });
    */
    //�������ҳ���ϵ�checkbox��ѡ��״̬
    /*$("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});*/
   	
    var wardRoundID="";
   
    //��ȡ����Ժ���߲鷿��¼��Ϣ
    $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getPatWardInf&AdmDr="+EpisodeID+"&Status="+"Out",
       dataType: "json",
      success: function(Data){
	      if(Data.RowId!=""){ 
		  	$('#OutRowId').val(Data.RowId);  				/// ��ID
	      	$('#OutPatGuideContent').val(Data.WRGuidance); /// ָ�����
	          var maxlimit=800;
		       if ($('#OutPatGuideContent').val().length >maxlimit){  
                   $('#OutPatGuideContent').val(($('#OutPatGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen3"]').val(maxlimit-$('#OutPatGuideContent').val().length);
		       }
	      	//���ù�ѡ���ѡ��״̬
	      	var checkList=Data.wrGuidanceList.substring(0,Data.wrGuidanceList.length).split("^");
	      	$("input[type='checkbox']").each(function(){
		       for(var i=0;i<checkList.length;i++){
		           /*if($(this).val()==checkList[i]&$(this).val()==1){
			           	//���value=1����������Ŀ������1.��ѡ��ǰ��2.������Ŀ��ʾ
			       		$(this).attr("checked",true);
			       		$(this).parent().parent().next().css("display","block");	
			       }else if($(this).val()==checkList[i]&$(this).val()!=1){
				        //���value!=1����������Ŀ����ֻ�蹴ѡ��ǰ��
				   		$(this).attr("checked",true);
				   }*/
				   if($(this).val()==checkList[i]){
				   $(this).attr("checked",true);
			       $(this).parent().parent().next().css("display","block");	
				   }
		       }
		  	});
		  	
		  	$('#otherGuiscopeO').val(Data.wrGuidanceOther);		/// ����  2017-09-13 yuliping
		  	//��ȡ�鷿��¼ID�����id�����ڣ����޲鷿��¼���򲻼���ҩƷ��Ϣ�б�
		  	wardRoundID=$('#OutRowId').val();
			if(wardRoundID!=""){
				$.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				$('#outdrugdg').datagrid('loadData',obj);
       				}
				})
			 } 				
          }
       }       
    });
     
}


/**
* �����ϻ������ݵ���ʾ����
* 1.��������Ŀ��ѡ�������
* 2.ÿ������$g("�༭����..")����ȡ���㡢ʧȥ���㣬���ݿ���
*/
function pageBasicControll(){
	//����name="checkboxMain"ѡ���������Ŀ����ʾ������
	
	$("input").bind('click',function(){
		$("input[name='checkboxMain']").each(function(){
			if($(this).attr("checked")){
				$(this).parent().parent().next().css("display","block");
			}else{
				$(this).parent().parent().next().css("display","none");
			}
		}) 
	})
	/*����Ժ*/
	$('#NewInPatGuideContent').focus(function(){
		if($(this).text()==$g("�༭����..")){
			$(this).text("");
		}
	})
	$('#NewInPatGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text($g("�༭����.."));
		}
	})
	
	/*סԺ�ڼ�*/
	$('#InPatGuideContent').focus(function(){
		if($(this).text()==$g("�༭����..")){
			$(this).text("");
		}
	})
	$('#InPatGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text($g("�༭����.."));
		}
	})
	
	/*��Ժ*/
	$('#OutPatGuideContent').focus(function(){
		if($(this).text()==$g("�༭����..")){
			$(this).text("");
		}
	})
	$('#OutPatGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text($g("�༭����.."));
		}
	})
		
}

//���ؽ����ʼdatagrid��ʾ
function InitPageData(){
	//����columns
	var columns=[[
		{field:"orditm",title:$g('orditm'),width:90,hidden:true},
	    {field:'incidesc',title:$g('����'),width:300,align:'left'},
	    //{field:'genenic',title:'ͨ����',width:300,align:'left'},
	    //{field:'manf',title:'������ҵ',width:300,align:'left'},
	    {field:'dosage',title:$g('����'),width:60,align:'left'}, 	/// ���Ӽ���-�Ƿ�ִ�� qunianpeng 2018/3/12
		{field:'instru',title:$g('�÷�'),width:60,align:'left'},
		{field:'freq',title:$g('Ƶ��'),width:60,align:'left'},
		{field:'duration',title:$g('�Ƴ�'),width:40,align:'left'},
		{field:'execStat',title:$g('�Ƿ�ִ��'),width:50,align:'left',hidden:true},
	    {field:'dgID',title:$g('dgID'),width:300,hidden:true},

		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//����datagrid
	$('#drugdg').datagrid({
		title:titleNotes,    
		url:'',
		height:165, 			/// �����������ɹ����� duwensheng 2016-09-13
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,		/// �к� 
	    remoteSort:false,		/// ��������
		fitColumns:true,    	/// duwensheng 2016-09-13 ����Ӧ��С����ֹ���򻬶�
		loadMsg: $g('���ڼ�����Ϣ...'),
	    onDblClickRow: function (rowIndex, rowData) {	
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//����datagrid
	$('#drugdatagrid').datagrid({
		title:titleNotes,    
		url:'',
		height:165,				 /// �����������ɹ����� duwensheng 2016-09-13
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,		/// ��������
		fitColumns:true,    	/// duwensheng 2016-09-13 ����Ӧ��С����ֹ���򻬶�
	    rownumbers:true,		/// �к� 
		loadMsg: $g('���ڼ�����Ϣ...'),
	    onDblClickRow: function (rowIndex, rowData) {
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdatagrid").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//����datagrid
	$('#outdrugdg').datagrid({
		title:titleNote,    
		url:'',
		height:165, 				/// �����������ɹ����� duwensheng 2016-09-13
		border:false,
		columns:columns,
	    singleSelect:true,
	    remoteSort:false,			/// ��������
		fitColumns:true,    		/// duwensheng 2016-09-13 ����Ӧ��С����ֹ���򻬶�
	    rownumbers:true,			/// �к� 
		loadMsg: $g('���ڼ�����Ϣ...'),
	    onDblClickRow: function (rowIndex, rowData) {
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#outdrugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	InitdatagridRow();
}

//��ʼ���б�ʹ��
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			///row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:'',dgID:'drugdg'}
			/// ����ҩƷ��Ϣ����� qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
		
		$("#drugdatagrid").datagrid('insertRow',{
			index: 0, 
			//row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:'',dgID:'drugdatagrid'}
			/// ����ҩƷ��Ϣ����� qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
		$("#outdrugdg").datagrid('insertRow',{
			index: 0, 
			//row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:'',dgID:'outdrugdg'}
			/// ����ҩƷ��Ϣ����� qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
	}
}

/// ����
function SetCellUrl(value, rowData, rowIndex)
{	
	//var dgID='"'+rowData.dgID+'"';
	if(Flag1==1){		 /// qunianpeng 2016/10/10 �������ǴӺ�̨����ʱ����rowData.dgID������
		var dgID='"'+'drugdg'+'"';
	}
	if(Flag2==1){
		var dgID='"'+'drugdatagrid'+'"';
	}
	if(Flag3==1){
		var dgID='"'+'outdrugdg'+'"';
	}
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

// ɾ����
function delRow(datagID,rowIndex)
{
	var selItem=$('#'+datagID).datagrid('getSelected');
	//���ѡ����кź�ɾ����ť���ڵ��к�һ�£���ɾ��
	//duwensheng 2016-09-13
	if(($('#'+datagID).datagrid("getRowIndex",selItem)+1)==(rowIndex+1)){
		//�ж���
    	var rowobj={
			//orditm:'', incidesc:'', genenic:'', manf:''	/// ����ҩƷ��Ϣ����� qunianpeng 2018/3/12
			orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''
		};

		//��ǰ��������4,��ɾ�����������
		//var selItem=$('#'+datagID).datagrid('getSelected');
		var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
		if(rowIndex=="-1"){
			$.messager.alert("��ʾ:","����ѡ���У�");
			return;
		}
		var rows = $('#'+datagID).datagrid('getRows');
		if(rows.length>4){
		 	$('#'+datagID).datagrid('deleteRow',rowIndex);
		}else{
			$('#'+datagID).datagrid('updateRow',{
				index: rowIndex, // ������
				row: rowobj
			});
		}
	
		// ɾ����,��������    duwensheng 2016-09-13 
		$('#'+datagID).datagrid('sort', {	        
			sortName: 'incidesc',
			sortOrder: 'desc'
		});
	}
	else{
		alert("��ѡ����ȷ�н���ɾ��!")
	}
}

/// ����ҩƷ����
function patOeInfoWindow()
{
	$('#mwin').window({
		title:$g('������ҩ�б�'),
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520,
		minimizable:false,					/// ������С����ť
		maximized:true,						/// ���(qunianpeng 2018/3/12)

	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//��ʼ��������ҩ�б�
function InitPatMedGrid()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20,disabled:true},
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:$g('���ȼ�'),width:80},
		{field:'StartDate',title:$g('��ʼ����'),width:80},
		{field:'EndDate',title:$g('��������'),width:80},
		{field:'incidesc',title:$g('����'),width:280},
		{field:'genenic',title:$g('����ͨ����'),width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:$g('����'),width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:$g('�÷�'),width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:$g('Ƶ��'),width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:$g('�Ƴ�'),width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'form',title:$g('����'),width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'doctor',title:$g('ҽ��'),width:80},
		{field:'execStat',title:$g('�Ƿ�ִ��'),width:80},		/// ����ִ��/��ҩ qunianpeng 2018/3/12
		{field:'sendStat',title:$g('�Ƿ�ҩ'),width:80},
		{field:'apprdocu',title:$g('��׼�ĺ�'),width:80},
		{field:'manf',title:$g('����'),width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true}

	]];
	
	//����datagrid
	$('#medInfo').datagrid({
		url:url+'&action=GetPatOEInfo',	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  			/// ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],    /// ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		rowStyler:function(index,row){
			if ((row.OeFlag=="D")||(row.OeFlag=="C")){
				return 'background-color:pink;';
			}
		},
		onClickRow:function(rowIndex, rowData){
			var flag=0;
			///��ȡ��ǰ���Ƿ�ѡ��
			if($('tr[datagrid-row-index='+rowIndex+']').hasClass('datagrid-row-checked')){
				var flag=1;
			}

			///һ��ҽ��ͬʱѡ��
			var items = $('#medInfo').datagrid('getRows');
			$.each(items, function(index, item){
				if(item.moeori==rowData.orditm){
					if(flag==1){
						$('#medInfo').datagrid('selectRow',index);
					}else{
						$('#medInfo').datagrid('unselectRow',index);
					}
				}
			})
		},
		queryParams:{
			params:EpisodeID,
			PriCode: $('input[name="ordFiter"]:checked').val()	
		},
		onLoadSuccess: function(data){
			if(Flag1 == 1){
				var selectedRows = $('#drugdg').datagrid('getRows');
			}else if(Flag2 == 1){
				var selectedRows = $('#drugdatagrid').datagrid('getRows');
			}else if(Flag3 == 1){
				var selectedRows = $('#outdrugdg').datagrid('getRows');	
			}else{
				return;	
			}
			$.each(data.rows, function (i, v) {
				for(var index in selectedRows){
					if(selectedRows[index].incidesc === v.incidesc){
						$('#medInfo').datagrid('selectRow', i);	
					}
				}
            });	
		}
	});
	$('#medInfo').datagrid('loadData', {total:0,rows:[]});
}

function addWatchDrg(){
	var ItemFlag="";  	/// qunianpeng 2016/10/10
	if(Flag1==1){
		var phaWardRid=$('#RowId').val();
		//����Ժ���߽���
		//��ҩ�б�
		var rows = $('#drugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}

		//��ȡҽ���б���ѡ����
		var checkedItems = $('#medInfo').datagrid('getChecked');
		if(checkedItems==""){
		 $.messager.alert("��ʾ:","����ѡ��ҩƷ��");
		 return;
		}
		/**
		*1.�����ʼ�鷿��¼rowid�����ڣ���ҩƷ�б���ʾΪ��ʼ��Ŀ
		*2.����鷿��¼rowid���ڣ�����ݹ�עҩƷ����datagrid��ʾ��ͨ��reload��ʽ
		*/
		$.each(checkedItems, function(index, item){
    		var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
	     		//manf:item.manf, dgID:'drugdg'
	     		/// �滻�е����� qunianpeng 2018/3/12
	     		orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdg'

			}
		for(var j=0;j<rows.length;j++){ /// qunianpeng 2016/10/10 ����ҩƷ���ظ����ж�
			if(item.incidesc==rows[j].incidesc){
				//ItemFlag=1;
				//alert("ҩƷ�б��Ѵ���'"+rows[j].genenic+"',������ѡ��!");
				//alert("ҩƷ�б��Ѵ���'"+rows[j].incidesc+"',������ѡ��!");
				return ;
			}
		}
    			if(k>3){
				$("#drugdg").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg").datagrid('updateRow',{	/// ��ָ����������ݣ�appendRow�������һ���������
					index: k, 						/// ������0��ʼ����
					row: rowobj
				});
			}
			k=k+1;
			  
		})
		
	}else if(Flag2==1){		
		var phaWardRid=$('#InPatRowid').val();
		//����Ժ���߽���
		//��ҩ�б�
		var rows = $('#drugdatagrid').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++){
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
	
		//��ȡҽ���б���ѡ����
		var checkedItems = $('#medInfo').datagrid('getChecked');  /// qunianpeng 2016/10/10 update
		if(checkedItems==""){
			 $.messager.alert("��ʾ:","����ѡ��ҩƷ��");
		 return;
		}
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//	manf:item.manf, dgID:'drugdatagrid'
		     	/// �滻�е����� qunianpeng 2018/3/12
	     		orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdatagrid'

			}
		for(var j=0;j<rows.length;j++){ 						/// qunianpeng 2016/10/10 ����ҩƷ���ظ����ж�
			if(item.incidesc==rows[j].incidesc){
				//ItemFlag=1;
				//alert("ҩƷ�б��Ѵ���'"+rows[j].incidesc+"',������ѡ��!");
				return ;

			}
		}
	    		if(k>3){
				$("#drugdatagrid").datagrid('appendRow',rowobj);
			}else{
				$("#drugdatagrid").datagrid('updateRow',{		/// ��ָ����������ݣ�appendRow�������һ���������
					index: k, 									/// ������0��ʼ����
					row: rowobj
				});
			}
			k=k+1;
			
    	})
		
	}else if(Flag3==1){
		//�鷿����
		//��ҩ�б�
		var rows = $('#outdrugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++){
			if(rows[i].orditm!=""){
				k=k+1;
			}
		}
	
		var checkedItems = $('#medInfo').datagrid('getChecked');
		if(checkedItems==""){
		 $.messager.alert("��ʾ:","����ѡ��ҩƷ��");
		 return;
		}
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//manf:item.manf, dgID:'outdrugdg'
		     	/// �滻�е����� qunianpeng 2018/3/12
	     		orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'outdrugdg'

		}
		for(var j=0;j<rows.length;j++){ 			/// qunianpeng 2016/10/10 ����ҩƷ���ظ����ж�
			if(item.incidesc==rows[j].incidesc){
				//ItemFlag=1;
				//alert("ҩƷ�б��Ѵ���'"+rows[j].incidesc+"',������ѡ��!");
				return ;
			}
		}
	    		if(k>3){
				$("#outdrugdg").datagrid('appendRow',rowobj);
			}else{
				$("#outdrugdg").datagrid('updateRow',{	/// ��ָ����������ݣ�appendRow�������һ���������
					index: k, 							/// ������0��ʼ����
					row: rowobj
				});
			}
			k=k+1;
			 
    	})
		//$('#mwin').window('close');
	}
	$.messager.alert("��ʾ:","��ӳɹ�");
	setTimeout(function(){
    	$(".messager-body").window('close');    
	},1000);
}
// �ر���ҩ�б���
function cancelWin()
{
	 $('#mwin').window('close');
}

///���ز�����ҩ�б�
function LoadPatMedInfo(priCode)
{
	$('#medInfo').datagrid({
		url:url+'&action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID,
			PriCode:priCode}
	});
}
//���˵������ı���Ϣ�пո�
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}

/*���Ƽ���ı���textarea�ĳ���*/
function textCounter(field, countfield, maxlimit) {  
   // ������3�������������֣�����Ԫ�����������ַ���  
   if (field.value.length > maxlimit){  
       //���Ԫ�����ַ�����������ַ�������������ַ����ضϣ�  
   	   field.value = field.value.substring(0, maxlimit); 
   }else{  
       //�ڼ������ı�������ʾʣ����ַ�����  
       countfield.value = maxlimit - field.value.length;  
   }
}

/**
* autor��   pengzhikun
* function: ��������Ժ�����������
*/
function saveNewInPatPhaWardInfo(){
	var rowid=$('#RowId').val();
	//�������
	var PatType="New";
	//���߿���Id
	var PatLoc=$('#AdmLoc').val();
	//���߲���Id
	var PatWard=$('#AdmWard').val();
	//��¼��
	var UserDr=session['LOGON.USERID'];
	//Ѫ��
	var BloodType=$('#patBloodType').val();
	//��Ժ���
	var AdmInf=$('#InHosdiag').val();    
	//ָ�����
	var content=$('#NewInPatGuideContent').val();
	if(content==$g("�༭����..")){
		content=""; 			/// qunianpeng 2017/11/22 ��ֹδ�������ݣ�������Ĭ������
	}
	//����
	var patWeight=$('#patWeight').val();
	///ע������
	var drugInstruction=""; 	/// $('#NewInPatInstruction').val();  qunianpeng 2017/11/23  ������Ŀ��Ҫ�ټ�
	
	//�鷿������Ϣ
	var wardMainInf=EpisodeID+"||"+PatWard+"||"+PatLoc+"||"+BloodType+"||"+AdmInf+"||"+PatType+"||"+content+"||"+UserDr+"||"+patWeight+"||"+drugInstruction
	
	//�ֲ�ʷ
	var PreDisHis= $('#PreDisHis').val();
	
	//������ʷ
	var PasDisHis=$('#PasDisHis').val();
	
	//������ҩʷ
	var PasMedHis=$('#PasMedHis').val();
	
	//����ʷ������ʷ
	var PerAndFamHis=$('#PerAndFamHis').val();
	
	//�鷢��������ҩ���
	var DisAndTre=$('#DisAndTre').val();
	
	//����ʷ
	var AllergicHis=$('#AllergicHis').val();
	
	if ((PreDisHis=="")||(PasDisHis=="")||(PasMedHis=="")||(PerAndFamHis=="")||(DisAndTre=="")||(AllergicHis=="")){	/// sufan 2016/09/13
		$.messager.alert("��ʾ","��¼�����������������룡");
		return;
		}
	
	//��ʼ���Ƽƻ�
	//����ѡ�е�checkbox duwensheng 2016-09-18
	var ckList=""
	$("input[type='checkbox']").each(function(){
		if ($(this).is(":checked")==true){
			if($(this).attr('value')!="-100"){
          	ckList+=$(this).attr('value')+"||";
			}
		}		
	})
	var otherGuiscope=""				/// yuliping 2017-09-13 ��������������
	otherGuiscope=$("#otherGuiscopeN").val();
	if((otherGuiscope!="")){
		ckList+="-100!"+otherGuiscope;
	}


	//�ص��עҩ��
	var tmpItmArr=[]
	var drugItems = $('#drugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	
	var input=wardMainInf+"^"+ckList+"^"+PreDisHis+"^"+PasDisHis+"^"+PasMedHis+"^"+PerAndFamHis
	     +"^"+DisAndTre+"^"+AllergicHis+"^"+tmpItmArr
	
	$.ajax({  
		type: 'POST',							/// �ύ��ʽ post ����get  
		url: url+'&action=SavePhaWardRoundInf',	/// �ύ������  
		data: "rowid="+rowid+"&"+"input="+input,/// �ύ�Ĳ���  
		success:function(msg){ 
			if(msg!=0){
				alert("����ʧ��,ʧ��״̬��Ϊ"+msg);
			}else{           
				alert("����ɹ�");
				clearData();
			}       
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
	
}

/**
* autor��   pengzhikun
* function: ����סԺ�ڼ仼���������
*/
function saveInPatPhaWardInfo(){
	
	var rowid=$('#InPatRowid').val();
	//�������
	var PatType="In";
	//���߿���Id
	var PatLoc=$('#AdmLoc').val();
	//���߲���Id
	var PatWard=$('#AdmWard').val();
	//��¼��
	var UserDr=session['LOGON.USERID'];
	
	//ָ�����
	var content=$('#InPatGuideContent').val();
	if ((content=="")||(content==$g("�༭����.."))){
		$.messager.alert("��ʾ","��¼�����������������룡");    //sufan  2016/09/13
		return;
		}
	///ע������
	var drugInstruction=""; 	/// $('#InPatInstruction').val(); qunianpeng 2017/11/23  ������Ŀ��Ҫ�����
	//�鷿������Ϣ
	var wardMainInf=EpisodeID+"||"+PatWard+"||"+PatLoc+"||"+""+"||"+""+"||"+PatType+"||"+content+"||"+UserDr+"||"+""+"||"+drugInstruction
	
	//------------------
	//����ѡ�е�checkbox duwensheng 2016-09-18
	var ckList=""
	$("input[type='checkbox']").each(function(){
		if ($(this).is(":checked")==true){
          	ckList+=$(this).attr('value')+"||";
		}		
	})
	var otherGuiscope=""
	otherGuiscope=$("#otherGuiscopeI").val();
	if((otherGuiscope!="")){
		ckList+="-100!"+otherGuiscope;
	}


	//�ص��עҩ��
	var tmpItmArr=[]
	var drugItems = $('#drugdatagrid').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	if(tmpItmArr==""){
		$.messager.alert("��ʾ","��¼�����������������룡");    //sufan  2016/09/13
		return;
		}
	var input=wardMainInf+"^"+ckList+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+tmpItmArr
	$.ajax({  
		type: 'POST',							/// �ύ��ʽ post ����get  
		url: url+'&action=SavePhaWardRoundInf', /// �ύ������  
		data: "rowid="+rowid+"&"+"input="+input,/// �ύ�Ĳ���  
		success:function(msg){ 
			if(msg!=0){
				alert("����ʧ��,ʧ��״̬��Ϊ"+msg);
			}else{           
				alert("����ɹ�");
				clearData();
			}       
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
}

/**
* autor��   pengzhikun
* function: �����Ժ�����������
*/
function saveOutPatPhaWardInfo(){
	
	var rowid=$('#OutRowId').val();
	//�������
	var PatType="Out";
	//���߿���Id
	var PatLoc=$('#AdmLoc').val();
	//���߲���Id
	var PatWard=$('#AdmWard').val();
	//��¼��
	var UserDr=session['LOGON.USERID'];
	
	//ָ�����
	var content=$('#OutPatGuideContent').val();
	if ((content=="")||(content==$g("�༭����.."))){
		$.messager.alert("��ʾ","��¼�����������������룡");   //sufan 2016/09/13
		return;
		}
		///ע������
	var drugInstruction=""; 	/// $('#OutPatInstruction').val(); qunianpeng 2017/11/23  ������Ŀ��Ҫ��
	//�鷿������Ϣ
	var wardMainInf=EpisodeID+"||"+PatWard+"||"+PatLoc+"||"+""+"||"+""+"||"+PatType+"||"+content+"||"+UserDr+"||"+""+"||"+drugInstruction
		
	//------------------
	//����ѡ�е�checkbox duwensheng 2016-09-18
	var ckList=""
	var otherGuiscope=""
	$("input[type='checkbox']").each(function(){
		if ($(this).is(":checked")==true){
			if($(this).attr('value')!="-100"){
				ckList+=$(this).attr('value')+"||";
			}
		}		
	})
	var otherGuiscope=""
	otherGuiscope=$("#otherGuiscopeO").val();
	if((otherGuiscope!="")){
		ckList+="-100!"+otherGuiscope;
	}
	
	//�ص��עҩ��
	var tmpItmArr=[]
	var drugItems = $('#outdrugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm;
		    tmpItmArr.push(tmp);
		}
	})
	if (tmpItmArr==""){
		$.messager.alert("��ʾ","��¼�����������������룡");   //sufan 2016/09/13
		return;
		}
	var input=wardMainInf+"^"+ckList+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',							/// �ύ��ʽ post ����get  
		url: url+'&action=SavePhaWardRoundInf', /// �ύ������  
		data: "rowid="+rowid+"&"+"input="+input, /// �ύ�Ĳ���  
		success:function(msg){ 
			if(msg!=0){
				alert("����ʧ��,ʧ��״̬��Ϊ"+msg);
			}else{           
				alert("����ɹ�");
				clearData();
			}       
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
	
	
}

function clearData(){
	window.location.reload();
	//window.parent.loadParWin();
}

function query(){
	 $('#recordWin').window({
		title:$g('ҩѧ�鷿��¼'),
		collapsible:true,
		border:false,
		closed:"true",
		width:600,
		height:520,
		minimizable:false						/// ������С����ť(qunianpeng 2018/3/15)
		//maximized:true						/// ���
	}); 

	$('#recordWin').window('open');
	//��ֹʱ��
	$("#startDate").datebox("setValue", formatDate(-1));
	$("#endDate").datebox("setValue", formatDate(0));
	
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_phaWardGrid(stDate,endDate);
}


//���˵�סԺ�ڼ�鷿��¼�б�
function find_phaWardGrid(stDate,endDate)
{
	
	//����columns
	var columns=[[
		{field:"wardRoundID",title:$g('RowID'),width:100},
		{field:'WRDate',title:$g('��¼����'),width:200},
		{field:'WRUser',title:$g('��¼��'),width:200}
	]];
	
	//����datagrid
	$('#phaWardRecord').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  				/// ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],  		/// ��������ÿҳ��¼�������б�
	    singleSelect:true,      /// nisijia   2016-09-23
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		onDblClickRow:function() { 
    		var selected = $('#phaWardRecord').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#recordWin').window('close');
 		     	/*��ȡ��¼ID*/
				$('#InPatRowid').val(selected.wardRoundID)
				$('#InPatInstruction').val(selected.WRDrugInstruction);
				$('#InPatGuideContent').val(selected.WRGuidance)
					var maxlimit=800;
		       if ($('#InPatGuideContent').val().length >maxlimit){  
                   $('#InPatGuideContent').val(($('#InPatGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen2"]').val(maxlimit-$('#InPatGuideContent').val().length);
		       }
				//��ȡ�鷿��¼ID�����id�����ڣ����޲鷿��¼���򲻼���ҩƷ��Ϣ�б�
		  		var wardRoundID=$('#InPatRowid').val();
				if(wardRoundID!=""){
					/*����ָ���б�*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getGuidList&wardRoundID="+wardRoundID,
      			 		//dataType: "json",
       					success: function(val){
	       					//���ù�ѡ���ѡ��״̬
	      					var checkList=val.split("^");
	      					$("input[type='checkbox']").each(function(){
		       					for(var i=0;i<checkList.length;i++){
		           					if(($(this).val()==checkList[i].trim())){
			           					//nisijia 2016-09-27 ���value=1����������Ŀ������1.��ѡ��ǰ��2.������Ŀ��ʾ
			       						$(this).attr("checked",true);
			       						$(this).parent().parent().next().css("display","block");	
			       					}
		       					}
		  					});	       					
       					}
					});
					
					/*������ҩ��Ϣ*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
      			 		//dataType: "json",
       					success: function(val){
	       					var obj = eval( "(" + val + ")" );
	       					$('#drugdatagrid').datagrid('loadData',obj);
       					}
					});
				 }					
      		}
		}
	});
	
	$('#phaWardRecord').datagrid({
		url:url+'&action=getPatWardRecord',	
		queryParams:{
			AdmDr:EpisodeID,
			Status:"In",
			startDate:stDate,
			endDate:endDate	
		}
	});
}

function queryByDate(){
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_phaWardGrid(stDate,endDate);
}

/// �״β��̼�¼ bianshuai 2015-01-20
function getPatFirProNote(EpisodeID)
{
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getPatFirProNote&EpisodeID="+EpisodeID,
		//dataType: "json",
		success: function(str){
			var patFirProNoteObj = jQuery.parseJSON(str);
			//���ò��̼�¼[�״β鷿]
			$("textarea[name=PatFirProNote]").each(function(){
				if(typeof patFirProNoteObj[this.id]!=undefined){
					$('#'+this.id).val(patFirProNoteObj[this.id]);
				}
			});
		}
	});
}

/// ��ʼ��ҳ�湫������  bianshuai 2015-03-09
function InitPageComInfo(EpisodeID)
{
	var retval=tkMakeServerCall("web.DHCSTPHCMCOMMON","GetPatEssInfo","",EpisodeID);
	if(retval==""){alert("��ȡ���˻�����Ϣ����");return;}
	var retvalArr=retval.split("^");
	
	$('#patID').val(retvalArr[0]);   //����ID
	$('#patName').val(retvalArr[3]); //��������
	$('#patSex').val(retvalArr[5]);  //�Ա�
	$('#patAge').val(retvalArr[6]);  //����
	$('#patNation').val(retvalArr[9]);  //����
	$('#patContact').val(retvalArr[14]); //��ϵ��ʽ
	$('#AdmLoc').val(retvalArr[16]); //����
	$('#AdmWard').val(retvalArr[18]);//����
	$('#patNativePlace').val(retvalArr[11])//����    //qunianpeng 2016-09-07 �ĵ�������λ
	$('#patWeight').val(retvalArr[12])//����
	$('#patHeight').val(retvalArr[13])//���
	$('#patWorkPlace').val(retvalArr[15])//������λ
}
/// ��ʼ��ָ����Χ add  by yuliping
function InitGuiScopeTable(){
	
	var subModType=new Array("N","I","O")
	var patlen=0;      //��¼���ڵ�ĸ�����סԺҪ�������
	for(var k=0;k<=2;k++){
	
	var tableId="#WAR"+subModType[k];
	var SubModType=subModType[k]
	//��ȡ���ڵ�
	var rtn=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","WAR",SubModType,"");
	/* var rtn=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
		{
			'ModType':"WAR",
			'SubModType':SubModType,
			'PatCode':""
	     }); */
	     
	var htmlStr=""
	if(rtn==""){
		//���ڵ�Ϊ�գ���ʾ��Ϣ
		 htmlStr= htmlStr+"<tr><td style='color:red'>$g('��ά���ֵ�!')"
		}else{
		rtnArr=rtn.split("!")
		patlen=rtnArr.length+1;
		//��ȡ�ӽڵ�
		for(var i=0;i<rtnArr.length;i++){
			var rtnArrs=rtnArr[i].split("^");
			var rtnChild=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","WAR",SubModType,rtnArrs[0]);
			/* var rtnChild=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
				{
					'ModType':"WAR",
					'SubModType':SubModType,
					'PatCode':rtnArrs[0]
		     	}); */
		     	

		     
		    if (rtnChild==""){
				htmlStr=htmlStr+"<tr><td><input type='checkbox' name='checkbox' value=\""+rtnArrs[2]+"\" class='GuiScope' />"+(i+1)+'��'+rtnArrs[1]+""
			
		    	}else{
			    	htmlStr=htmlStr+"<tr><td><input type='checkbox' name='checkboxMain' value=\""+rtnArrs[2]+"\" class='GuiScope' />"+(i+1)+'��'+rtnArrs[1]+"</td></tr>"
			   		ChildArr=rtnChild.split("!");
			   		var html="<tr style='display:none'><td>";
		   		
					for(var j=0;j<ChildArr.length;j++){
						Child=ChildArr[j].split("^")
					
						html=html+"<input type='checkbox' name='checkbox' value=\""+Child[2]+"\" style='margin-left:40px' class='GuiScope' />"+(i+1)+'.'+(j+1)+'��'+Child[1]+"<br />"
							
				
					}
					htmlStr=htmlStr+html;
			    }
				
			}

		}
		//qunianpeng 2017/11/28 ע�� ����
		//var inputid="checkGui"+subModType[k]
		//var inputId="otherGuiscope"+subModType[k]
		//if(htmlStr!=""){htmlStr=htmlStr+"<tr><td><input type='checkbox' name='checkboxMain' value='-100' class='GuiScope' id='"+inputid+"'/>"+patlen+"������</td></tr><tr style='display:none'><td><input id='"+inputId+"' style='margin-left:40px;' ></input></td></tr>"}
		htmlStr=htmlStr+"</td></tr>"
		$(tableId).append(htmlStr)
	}
}

/// ��ӡ����Ժҩѧ�鷿��¼
function printNewInPatPhaWardInfo(){
	var PhawardNewID=$('#RowId').val();
	print_NewInPatPhaWardInfo(PhawardNewID);
}

/// ��ӡ��Ժ����ҩѧ�鷿��¼
function printInPatPhaWardInfo(){
	var PhawardID=$('#InPatRowid ').val();
	print_InPatPhaWardInfo(PhawardID);
}

/// ��ӡ��Ժ����ҩѧ�鷿��¼
function printOutPatPhaWardInfo(){
	var PhawardOutID=$('#OutRowId').val();
	print_OutPatPhaWardInfo(PhawardOutID);
}
/// ��ӡȫ��ҩѧ�鷿��¼
function printPhaWardInfoAll(){
	var phawIdStr = tkMakeServerCall("web.DHCSTPHCMWARDROUND","GetPhaWardStr",EpisodeID)
	if(phawIdStr == ""){
		$.messager.alert("��ʾ","û��ҩѧ�鷿��¼��");
		return;
	}
	var phawIdArr = phawIdStr.split("#");
	var status,phawId;
	for(var i in phawIdArr){
		status = phawIdArr[i].split("^")[0];
		phawId = phawIdArr[i].split("^")[1];
		if((!phawId)||(!status)){
			continue;	
		}
		if(status == "N"){
			print_NewInPatPhaWardInfo(phawId);
		}else if(status == "I"){
			print_InPatPhaWardInfo(phawId);
		}else if(status == "O"){
			print_OutPatPhaWardInfo(phawId);
		}
	}
}