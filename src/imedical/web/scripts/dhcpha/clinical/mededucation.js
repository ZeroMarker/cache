
/*
* ��ҩ����
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
var titleNote='<span style="font-weight:bold;">ҽ����ҩ�б�</span>';
var titleNotes='<span style="font-weight:bold;">��Ժ��ҩ�б�</span>';
var EpisodeID="";
var choseFlag=""; 				 /// ��Ժ���߼��س�Ժ��ҩ��־ qunianpeng 2018/3/12

$(document).ready(function(){
	
	InitGuiScopeTableEDU();		/// ��ʼ����Ժָ����Χ add  by yuliping // ָ����Χ��Ϊ��̬���� ��Ҫ�ȼ�����ɺ󣬲��ܸ�ֵ  qunianpeng  2018/3/19
	InitGuiScopeTableEDUI();	/// ��ʼ��סԺָ����Χ add  by yuliping
	
	EpisodeID=getParam("EpisodeID")		/// Ĭ�ϴ�����Ժ���߽��� qunianpeng 2018/3/12
 	choseMenu("����Ժ����");
	$('.easyui-accordion ul li a:contains("����Ժ����")').css({"background":"#87CEFA"});		

	//���ݵ����ϸ��ʾ����panel
	$('.easyui-accordion ul li a').click(function(){
		$('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		$(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //�����˵�����ʾ��Ӧ����
		 choseMenu(panelTitle);
	});	
	pageBasicControll();
	initDataDG();	
})

function choseMenu(item){
	switch(item){
		case "����Ժ����":
			//��ֹ�ظ����������ʱFlag=1�����²�ִ�д�������
			if(Flag1==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"����Ժ����"��panel
				createPanel();
				//����mainPanel�ɼ�
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[��ɫ*�ű�ע��Ϊ������]</span>"
				});
			}
			
			break;
			
		case "סԺ�ڼ仼��":
			if(Flag2==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"סԺ�ڼ仼��"��panel
				createInHopPanel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[��ɫ*�ű�ע��Ϊ������]</span>"
				});
				//��������
				//loadData();
			}
			break;
			
		case "��Ժ����":
			if(Flag3==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"סԺ�ڼ仼��"��panel
				createOutHopPanel();
				$('#mainPanel').css("display","block");
				$('#mainPanel').panel({
					title:item+"<span style='color:red;'>[��ɫ*�ű�ע��Ϊ������]</span>"
				});
				//��������
				//loadData();
			}
			break;
			
		default:
			break;	
	}
				 	
} 

//--����"����Ժ����"������--//
var Flag1=0;//��ֹ�ظ��������δ������
function createPanel() {
	if(Flag1==0){
		//����ʾ��ѯ������
		$("#content1").css("display","block");
		Flag1=1;
		Flag2=0;
		Flag3=0;
		//��ʼ���صĲ�����Ϣ
		InitPatientInfo(EpisodeID);
		
	}
} 

//���ر���Ĭ����Ϣ
function InitPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   
    //�������ҳ���ϵ�checkbox��ѡ��״̬
    $("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});
   
   var medEduRid="";
   var medEduInfo=tkMakeServerCall("web.DHCPHMEDEDUCATION","getMedEducation",EpisodeID,"New");
   if(medEduInfo==""){
       InitNewPagePatInfo(EpisodeID);
       return;
   }
   LoadNewPagePatInfo(EpisodeID,medEduInfo);
}

//��ȡ����Ժ���߲鷿��¼��Ϣ
function LoadNewPagePatInfo(EpisodeID,medEduInfo)
{
  	var tmps=medEduInfo.split("!");
  	var listMain=tmps[0].split("^"); 		/// ����Ϣ
  	
  	$('#NewRowId').val(listMain[18]);         	/// ��ID
	$('#newPatName').val(listMain[1]);		/// ��������
	$('#newPatSex').val(listMain[3]);    	/// �Ա�
	$('#newPatAge').val(listMain[4]);    	/// ����
	$('#newPatMedRec').val(listMain[0]); 	/// ������
	$('#newPatTel').val(listMain[7]);    	/// ��ϵ��ʽ
	$('#newPatAddr').val(listMain[19]); 	/// ��ͥ��ַ
	$('#newPatBed').val(listMain[2])     	/// ����
  	$('#BadHabits').val(listMain[12]);      /// �����Ⱥ�
  	$('#NewPatAdmInf').val(listMain[17]);   /// ��Ժ���
  	$('#ConDisAndTre').val(listMain[13]);   /// �鷢��������ҩ���
  	$('#NewPatGuidCont').val(listMain[16]); /// ��ע
    
  	var GrantFlag=listMain[14];				/// GrantFlag--�����ٴ�ҩʦ��ϵ��
  	$("input[type='radio'][name='GrantFlag']").each(function(){
	  	if($(this).val()==GrantFlag){
			$(this).attr("checked",true);
		}
	});
	
  	var GuidObject=listMain[15];			/// GuidObject--ָ������
  	$("input[type='radio'][name='GuidObject']").each(function(){
	  	if($(this).val()==GuidObject){
			$(this).attr("checked",true);
		}
	});
  
  	//���ù�ѡ���ѡ��״̬
  	var checkList=tmps[1].substring(0,tmps[1].length-1).split("^");
  	$("input[type='checkbox'][name='GuiContent']").each(function(){
       for(var i=0;i<checkList.length;i++){
           if($(this).val()==checkList[i]){
	       		$(this).attr("checked",true);		
	       }
       }
  	});
}

//��ȡ���˻�����Ϣ
function InitNewPagePatInfo(EpisodeID)
{   
   $.ajax({type: "POST", url: url, data: "action=GetPatInfo&AdmDr="+EpisodeID, 
	   success: function(val){
			tmp=val.split("^");
			//������Ϣ
			//$('#patID').val(tmp[9]);		/// ����ID
			$('#newPatName').val(tmp[1]);	/// ��������
			$('#newPatSex').val(tmp[2]); 	/// �Ա�
			$('#newPatAge').val(tmp[3]); 	/// ����
			$('#newPatMedRec').val(tmp[0]); /// ������
			$('#newPatTel').val(tmp[14]);   /// ��ϵ��ʽ
			$('#newPatBed').val(tmp[4])     /// ����
			$('#NewPatAdmInf').val(tmp[8])  /// ��Ժ���
			$('#newPatAddr').val(tmp[15])   /// ��Ժ���˵�ַ  2016/09/14
			
	   }
   })
}

//--����"סԺ�ڼ仼��"������--//
var Flag2=0;//��ֹ�ظ��������δ������
function createInHopPanel(){
	if(Flag2==0){
		//����ʾ��ѯ������
		$("#content2").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		InitInPatientInfo(EpisodeID)
	}
}

//����Ĭ����Ϣ
function InitInPatientInfo(EpisodeID)
{
    if(EpisodeID==""){return;}
   //��ȡ���˻�����Ϣ
    $.ajax({
		type: "POST",
		url: url,
		data:{action:'GetPatEssInfo',EpisodeID:EpisodeID},	/// nisijia 2016-09-21
		//dataType: "json",
    	success: function(jsonString){ 
     		var adrRepObj = jQuery.parseJSON(jsonString);     		
     		 $('#InPatSex').val(adrRepObj.patsex);    		/// �Ա�
     		 $('#InPatName').val(adrRepObj.patname);    	/// ����
     		 $('#InPatBed').val(adrRepObj.admbed);    		/// ����
     		 $('#InPatMedRec').val(adrRepObj.patno);    	/// �ǼǺ�
	   		 $('#InPatAdmInf').val(adrRepObj.patdiag);    	/// ���		
  			}       
   });
    //�������ҳ���ϵ�checkbox��ѡ��״̬
    $("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});
   
}


//--����"��Ժ����"������--//
var Flag3=0;//��ֹ�ظ��������δ������
function createOutHopPanel(){
	if(Flag3==0){
		//����ʾ��ѯ������
		$("#content3").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		/* $('a:contains("�ύ����")').unbind("click");  /// qunianpeng 2016/10/11 ���¼�ǰ����գ���ֹ��ΰ�
		$('a:contains("��ӡ����")').unbind("click");
		
		$('a:contains("�ύ����")').click(function(){  	 /// qnp 2017/03/08 �󶨵�csp��
			saveOutPatEduInf();
		})
		$('a:contains("��ӡ����")').click(function(){
			printMedEducation();
		}) */
		InitOutPatientInfo(EpisodeID);		
		choseFlag = "OUT";								/// ѡ��tab���ñ�־(��Ժ����ҽ������ҪĬ�ϼ��س�Ժ��ҩ) qunianpeng 2018/3/12
	}	
}

//����Ĭ����Ϣ
function InitOutPatientInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   //��ȡ���˻�����Ϣ
   $.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetPatInfo&AdmDr="+EpisodeID,
       //dataType: "json",
       success: function(val){
		  tmp=val.split("^");		 
		  //������Ϣ
		  //$('#patID').val(tmp[9]);        //����ID
		  $('#OutPatNo').val(tmp[0]);       //סԺ��
		  $('#OutPatName').val(tmp[1]);     //��������
		  $('#OutPatSex').val(tmp[2]);      //�Ա�
		  $('#OutPatAge').val(tmp[3]);      //����
		  $('#OutPatBed').val(tmp[4]);      //����
		  $('#OutPatAdmInf').val(tmp[9]);   //��Ժ���   //sufan 2016/09/14
		  $('#OutWUser').text(session['LOGON.USERNAME']);
       }
   });
    //$('#OutPatLoc').val(window.status.split("����:")[1].split("-")[1]);     //����
    //�������ҳ���ϵ�checkbox��ѡ��״̬
    $("input[type='checkbox']").each(function(){
	    $(this).attr("checked",false);
	});
   
    var medEduRid="";
   
    //��ȡ����Ժ���߲鷿��¼��Ϣ
    $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getMedEducation&AdmDr="+EpisodeID+"&Status="+"Out",
       //dataType: "json",
       success: function(val){
	      if(val!=-999){
		  	var tmps=val.split("!");
		  	var listMain=tmps[0].split("^");	/// ����Ϣ
		  	$('#OutRowId').val(listMain[18]);	/// ��ID
		  	$('#OutWUser').text(listMain[9]);	/// �ٴ�ҩʦ

 		  	var listdate=listMain[10].split("-")  //sufan 2016/09/21
		  	$("#year").text(listdate[0]);
		  	$("#month").text(listdate[1]);
		  	$("#day").text(listdate[2]);
	      	$('#OutPatGuidCont').val(listMain[16]);  //ָ�����
              var maxlimit=800;
		       if ($('#OutPatGuidCont').val().length >maxlimit){  
                   $('#OutPatGuidCont').val(($('#OutPatGuidCont').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen1"]').val(maxlimit-$('#OutPatGuidCont').val().length);
		       }
		  	//��ȡ�鷿��¼ID�����id�����ڣ����޲鷿��¼���򲻼���ҩƷ��Ϣ�б�
		  	medEduRid=$('#OutRowId').val();
			if(medEduRid!=""){
				$.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getMEDrgItm&medEduRid="+medEduRid,
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

function pageBasicControll(){
	
	//ҩʦ��Ϣ
	//$('#newPatDocLoc').val(window.status.split("����:")[1].split("-")[1]) //����
	$('#newPatDocLoc').val(LocDesc) 				/// ����
	$('#newPatDoc').val(session['LOGON.USERNAME']) 	/// �ٴ�ҩʦ
	//ʱ��
	$("#newPatDate").datebox("setValue", formatDate(-1));
	
	//ҩʦ��Ϣ
	//$('#InPatDocLoc').val(window.status.split("����:")[1].split("-")[1]) //����
	$('#InPatDocLoc').val(LocDesc) 					/// ����
	$('#InPatDoc').val(session['LOGON.USERNAME']) 	/// �ٴ�ҩʦ
	$("#InPatDate").datebox("setValue", formatDate(-1));
	
	$('#OutPatLoc').val(LocDesc);    				/// ����
	$('#OutPatGuidCont').focus(function(){
		if($(this).text()=="�༭����.."){
			$(this).text("");
		}
	})
	$('#OutPatGuidCont').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("�༭����..");
		}
	})
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

//��ʼ������datagrid��ʾ
function initDataDG(){
	//����columns
	var columns=[[
		{field:"orditm",title:'orditm',width:100,hidden:true},
	    {field:'incidesc',title:'����',width:330,align:'left'},
		//{field:'genenic',title:'ͨ����',width:240,align:'left'},
		//{field:'manf',title:'������ҵ',width:240,align:'left'},
		{field:'dosage',title:'����',width:40,align:'left'},		/// ���Ӽ���-�Ƿ�ִ�� qunianpeng 2018/3/12
		{field:'instru',title:'�÷�',width:40,align:'left'},
		{field:'freq',title:'Ƶ��',width:60,align:'left'},
		{field:'duration',title:'�Ƴ�',width:40,align:'left'},
		{field:'execStat',title:'�Ƿ�ִ��',width:50,align:'left',hidden:true},
	    {field:'dgID',title:'dgID',width:100,hidden:true},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//����datagrid
	$('#drugdg').datagrid({
		title:titleNote, 
		url:'',
		height:165, //�����������ɹ����� duwensheng 2016-09-12
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,						/// �к� 
	    remoteSort:false,						/// ��������
		fitColumns:true,    					/// duwensheng 2016-09-12 ����Ӧ��С����ֹ���򻬶�		
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#drugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//����datagrid
	$('#outdrugdg').datagrid({
		title:titleNotes,    
		url:'',
		height:165, 					/// �����������ɹ����� duwensheng 2016-09-12
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,				/// �к� 
	    remoteSort:false,				/// ��������
		fitColumns:true,    			/// duwensheng 2016-09-12 ����Ӧ��С����ֹ���򻬶�
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#outdrugdg").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	InitdatagridRow();

}
/// ����
function SetCellUrl(value, rowData, rowIndex)
{	
	//var dgID='"'+rowData.dgID+'"';
	if(Flag2==1){//lbb  סԺ֮ǰ����
    var dgID='"'+'drugdg'+'"';
   }
   if(Flag3==1){//lbb   ��Ժ����
   var dgID='"'+'outdrugdg'+'"';
   }
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}
//��ʼ���б�ʹ��
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			//row: {dgID:'drugdg',orditm:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',spec:''}
			/// ����ҩƷ��Ϣ����� qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}

		});
		
		$("#outdrugdg").datagrid('insertRow',{
			index: 0, 
			//row: {dgID:'outdrugdg',orditm:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',spec:''}
			/// ����ҩƷ��Ϣ����� qunianpeng 2018/3/12
			row: {dgID:'drugdg',orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''}			

		});
	}
}


function delRow(datagID,rowIndex)
{
	var selItem=$( '#'+datagID).datagrid('getSelected');
	//���ѡ����кź�ɾ����ť���ڵ��к�һ�£���ɾ��
	//duwensheng 2016-09-13
	if(($( '#'+datagID).datagrid("getRowIndex",selItem)+1)==(rowIndex+1)){
		//�ж���
    	var rowobj={
			//orditm:'', incidesc:'', genenic:'', manf:''			/// ����ҩƷ��Ϣ����� qunianpeng 2018/3/12
			orditm:'',incidesc:'',dosage:'',instru:'',freq:'',duration:'',execStat:''
		};
	
		//��ǰ��������4,��ɾ�����������
		//var selItem=$('#'+datagID).datagrid('getSelected');
		var rowIndex = $( '#'+datagID).datagrid('getRowIndex',selItem);
		if(rowIndex=="-1"){
			$.messager.alert("��ʾ:","����ѡ���У�");
			return;
		}
		var rows = $( '#'+datagID).datagrid('getRows');
		if(rows.length>4){
		 	$( '#'+datagID).datagrid('deleteRow',rowIndex);
		}else{
			$( '#'+datagID).datagrid('updateRow',{
				index: rowIndex, // ������
				row: rowobj
			});
		}
	
		// ɾ����,��������    duwensheng 2016-09-12 
		$( '#'+datagID).datagrid('sort', {	        
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
		title:'������ҩ�б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520,
		minimizable:false,					/// ������С����ť
		maximized:true						/// ���(qunianpeng 2018/3/12)

	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//��ʼ��������ҩ�б�
function InitPatMedGrid()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"moeori",title:'moeori',width:90,hidden:true},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'priorty',title:'���ȼ�',width:80},
		{field:'StartDate',title:'��ʼ����',width:80},
		{field:'EndDate',title:'��������',width:80},
		{field:'incidesc',title:'����',width:280},
		{field:'genenic',title:'����ͨ����',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'����',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'Ƶ��',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'�Ƴ�',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'form',title:'����',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true},
		{field:'doctor',title:'ҽ��',width:80},
		{field:'execStat',title:'�Ƿ�ִ��',width:80},		/// ����ִ�кͷ�ҩ qunianpeng 2018/3/12
		{field:'sendStat',title:'�Ƿ�ҩ',width:80},
		{field:'apprdocu',title:'��׼�ĺ�',width:80},
		{field:'manf',title:'����',width:80}, 
		{field:'manfdr',title:'manfdr',width:80,hidden:true}

	]];
	
	//����datagrid
 	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  			/// ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],    /// ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		rowStyler:function(index,row){
			if ((row.OeFlag=="D")||(row.OeFlag=="C")){
				return 'background-color:pink;';
			}
		},onClickRow:function(rowIndex, rowData){
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
			PriCode:choseFlag}
	});		
	$('#medInfo').datagrid('loadData', {total:0,rows:[]});	
}

function addWatchDrg(){
	if(Flag2==1){
		var rows = $('#drugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		//��ѡ��ʾ duwensheng 2016-09-12
		var checkedItems = $('#medInfo').datagrid('getChecked');
		if(checkedItems==""){
		 $.messager.alert("��ʾ:","����ѡ��ҩƷ��");
		 return;
		}
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//manf:item.manf, dgID:'drugdg'
		     	/// �滻�е����� qunianpeng 2018/3/12
		    	orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdg'

			}
			
			//�б��Ѵ������ݵĻ�,��ʾ���˳�
			//duwensheng 2016-09-12
			for(var j=0;j<rows.length;j++){
			if(item.incidesc==rows[j].incidesc){
				//alert("ҩƷ�б��Ѵ���'"+rows[j].incidesc+"',���ʧ��!");
				return;
			}
		}
	    	if(k>3){
				$("#drugdg").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
					index: k, // ������0��ʼ����
					row: rowobj
				});
			}
			k=k+1;
    	})
   	
	}else if(Flag3==1)
	 {
		//�鷿����
		//��ҩ�б�
		
		var rows = $('#outdrugdg').datagrid('getRows');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		//��ѡ��ʾ duwensheng 2016-09-12
		var checkedItems = $('#medInfo').datagrid('getChecked');
		if(checkedItems==""){
		 $.messager.alert("��ʾ:","����ѡ��ҩƷ��");
		 return;
		}
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				//orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	//manf:item.manf, dgID:'outdrugdg'
		     	/// �滻�� qunianpeng 2018/3/12
		     	orditm:item.orditm, incidesc:item.incidesc, dosage:item.dosage,instru:item.instru,freq:item.freq,
		     	duration:item.duration,execStat:item.execStat,dgID:'drugdg'
			}
			//�б��Ѵ������ݵĻ�,��ʾ���˳�
			//duwensheng 2016-09-12
			for(var j=0;j<rows.length;j++){
			if(item.incidesc==rows[j].incidesc){
				//alert("ҩƷ�б��Ѵ���'"+rows[j].incidesc+"',���ʧ��!");
				return;
			}
		}
	    	if(k>3){
				$("#outdrugdg").datagrid('appendRow',rowobj);
			}else{
				$("#outdrugdg").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
					index: k, // ������0��ʼ����
					row: rowobj
				});
			}
			k=k+1;
    	})
    	
	}
	$.messager.alert("��ʾ:","��ӳɹ�");
	setTimeout(function(){
    	$(".messager-body").window('close');    
	},1000);
	//$('#mwin').window('close');
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
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID,
			PriCode:priCode}
	});
}

//����"����Ժ����"��ҩ������Ϣ
function saveNewPatEduInf(){
	var CurStatus="New";
	var BadHabits=$('#BadHabits').val(); 		/// �����Ⱥ�
	var Icd=$('#NewPatAdmInf').val();    		/// ���
	var ConDisAndTre=$('#ConDisAndTre').val();  /// �鷢��������ҩ���
	var modPhone=$('#newPatTel').val();    		/// ��ϵ��ʽ
	var address=$('#newPatAddr').val();    		/// ��ͥ��ַ
	
	var GrantFlag="";  							/// �����ٴ�ҩʦ��ϵ��
	$('input[type=radio][name=GrantFlag]').each(function(){
		if ($(this).attr("checked")){
			GrantFlag=$(this).val();
		}
	})
	
	var GuidObject="";  						/// ָ������
	$('input[type=radio][name=GuidObject]').each(function(){
		if ($(this).attr("checked")){
			GuidObject=$(this).val();
		}
	})
	var GuiContentList=""; 						/// ������ҩָ������
	$('input[type=checkbox][name=GuiContent]').each(function(){
		if ($(this).attr("checked")){
			GuiContentList+=$(this).val()+"||";
		}
	})
	if(GuiContentList!=""){
		GuiContentList=GuiContentList.substring(0,GuiContentList.length-2);
	}
	

	var NewPatGuidCont=$('#NewPatGuidCont').val(); /// ��ע(����ָ����ϸ)
	//sufan 2016/09/13
	if ((BadHabits=="")||(ConDisAndTre=="")||(GrantFlag=="")||(GuidObject=="")||(GuiContentList=="")||(NewPatGuidCont=="")){
		$.messager.alert("��ʾ","��¼�����������������룡");
		return;
		}

	//��¼��
	var UserDr=session['LOGON.USERID'];

	var medEduMasDataList=EpisodeID+"^"+CurStatus+"^"+BadHabits+"^"+ConDisAndTre+"^"+GrantFlag+"^"+GuidObject+"^"+NewPatGuidCont+"^"+UserDr+"^"+Icd+"^"+modPhone+"^"+address;
	
	var rowid=$('#NewRowId').val()
	var medEduDrgItmList="";				 /// ��ҩ���
	
	var input=medEduMasDataList+"!"+GuiContentList+"!"+medEduDrgItmList;

	$.ajax({  
		type: 'POST',						 /// �ύ��ʽ post ����get  
		url: url+'?action=SaveMedEduInf',	 /// �ύ������    sufan 2016/09/18
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


//����"סԺ�ڼ仼��"��ҩ������Ϣ
function saveInPatEduInf(){
	var CurStatus="In";
	var BadHabits=""; 					/// �����Ⱥ�
	var Icd=$('#InPatAdmInf').val();   	/// ���
	var ConDisAndTre="";  				/// �鷢��������ҩ���
	var GrantFlag="";  					/// �����ٴ�ҩʦ��ϵ��
	var GuidObject="";  				/// ָ������
	$('input[type=radio][name=InGuidObject]').each(function(){
		if ($(this).attr("checked")){
			GuidObject=$(this).val();
		}
	})
	var GuiContentList=""; 				/// ������ҩָ������
	$('input[type=checkbox][name=InGuiContent]').each(function(){
		if ($(this).attr("checked")){
			GuiContentList+=$(this).val()+"||";
		}
	})
	if(GuiContentList!=""){
		GuiContentList=GuiContentList.substring(0,GuiContentList.length-2);
	}
	
	var InPatGuidCont=$('#InPatGuidCont').val(); /// ��ע(����ָ����ϸ) 
	
	if ((GuidObject=="")||(GuiContentList=="")||(InPatGuidCont=="")){   //sufan 2016/09/13
		$.messager.alert("��ʾ","��¼�����������������룡");
		return;
		}
	//��¼��
	var UserDr=session['LOGON.USERID'];

	var medEduMasDataList=EpisodeID+"^"+CurStatus+"^"+BadHabits+"^"+ConDisAndTre+"^"+GrantFlag+"^"+GuidObject+"^"+InPatGuidCont+"^"+UserDr+"^"+Icd;
	
	var rowid=$('#InPatEduRid').val();
	
	//�ص��עҩ��
	var medEduDrgItmList=[] ;		/// ��ҩ���
	var drugItems = $('#drugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm;
		    medEduDrgItmList.push(tmp);
		}
	})
	if (medEduDrgItmList==""){		/// sufan 2016/09/13
		$.messager.alert("��ʾ","��¼�����������������룡");
		return;
		}
	var input=medEduMasDataList+"!"+GuiContentList+"!"+medEduDrgItmList;
	
	$.ajax({  
		type: 'POST',							/// �ύ��ʽ post ����get   
		url: url+'?action=SaveMedEduInf',		/// �ύ������    sufan 2016/09/18 
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


//����"��Ժ����"��ҩ������Ϣ
function saveOutPatEduInf(){
	var CurStatus="Out";
	var BadHabits="";					/// �����Ⱥ�
	var Icd=$('#OutPatAdmInf').val();   /// ���
	var ConDisAndTre="";				/// �鷢��������ҩ���
	
	var GrantFlag="";					/// �����ٴ�ҩʦ��ϵ��

	var GuidObject="";					/// ָ������
	
	var GuiContentList="";				/// ������ҩָ������
	
	var InPatGuidCont=$('#OutPatGuidCont').val();			  /// ��ע(����ָ����ϸ)
	if ((InPatGuidCont=="")||(InPatGuidCont=="�༭����..")){  /// sufan 2016/09/13
		$.messager.alert("��ʾ","��¼�����������������룡");
		return;
		}
	//��¼��
	var UserDr=session['LOGON.USERID'];

	var medEduMasDataList=EpisodeID+"^"+CurStatus+"^"+BadHabits+"^"+ConDisAndTre+"^"+GrantFlag+"^"+GuidObject+"^"+InPatGuidCont+"^"+UserDr+"^"+Icd;
	
	var medEduOutID=$('#OutRowId').val();
	
	//�ص��עҩ��
	var medEduDrgItmList=[] ;		/// ��ҩ���
	var drugItems = $('#outdrugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm;
		    medEduDrgItmList.push(tmp);
		}
	})
	
	var input=medEduMasDataList+"!"+GuiContentList+"!"+medEduDrgItmList;
	
	$.ajax({  
		type: 'POST',						/// �ύ��ʽ post ����get  
		url: url+'?action=SaveMedEduInf',	/// �ύ������    sufan 2016/09/18
		data: "rowid="+medEduOutID+"&"+"input="+input,//�ύ�Ĳ���  
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
}

function query(){
	 $('#recordWin').window({
		title:'��ҩ������¼',	/// by qunianpeng 2017/1/05
		collapsible:true,
		border:false,
		closed:"true",
		width:600,
		height:520,
		minimizable:false		/// ������С����ť(qunianpeng 2018/3/15)
		//maximized:true		/// ���
	}); 

	$('#recordWin').window('open');
	//��ֹʱ��
	$("#startDate").datebox("setValue", formatDate(-1));
	$("#endDate").datebox("setValue", formatDate(0));
	
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_medEduGrid(stDate,endDate);
}


//���˵�סԺ�ڼ�鷿��¼�б�
function find_medEduGrid(stDate,endDate)
{
	
	//����columns
	var columns=[[
		{field:"medEduID",title:'RowID',width:100},
		{field:'EDDate',title:'��¼����',width:200},
		{field:'EDUser',title:'��¼��',width:200}
	]];
	
	//����datagrid
	$('#MedEduRecord').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  			/// ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],    /// ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onClickRow:function() { /// ˫���¼���Ϊ����¼� by qnp 2017/1/5
    		var selected = $('#MedEduRecord').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#recordWin').window('close');
 		     	/*��ȡ��¼ID*/
				$('#InPatEduRid').val(selected.medEduID)
				$('#InPatGuidCont').val(selected.MEGuidContent)
				
				
				var GuidObject=selected.MEGuidObject; //GuidObject--ָ������
		  		$("input[type='radio'][name='InGuidObject']").each(function(){
			  		if($(this).val()==GuidObject){
						$(this).attr("checked",true);
					}
			    });
				
				
				//��ȡ�鷿��¼ID�����id�����ڣ����޲鷿��¼���򲻼���ҩƷ��Ϣ�б�
		  		var EduRid=$('#InPatEduRid').val();
				if(EduRid!=""){
					/*����ָ���б�*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getGuidContList&EduRid="+EduRid,
      			 		//dataType: "json",
       					success: function(val){
	       					//���ù�ѡ���ѡ��״̬
	      					var checkList=val.substring(0,val.length-1).split("^");
	      					
	      					//���ù�ѡ���ѡ��״̬	      				
	      					$("input[type='checkbox'][name='InGuiContent']").each(function(){
		       					
		       					for(var i=0;i<checkList.length;i++){
		           					if($(this).val()==(checkList[i].trim())){
			       						$(this).attr("checked",true);		
			       					}
		       					}
		  					});
		  		
       					}
					});
					
					/*������ҩ��Ϣ*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data:"action=getMEDrgItm&medEduRid="+EduRid,
      			 		//dataType: "json",
       					success: function(val){
	       					var obj = eval( "(" + val + ")" );
	       					$('#drugdg').datagrid('loadData',obj);
       					}
					});
			 } 	
					
      		}
		}
	});

	$('#MedEduRecord').datagrid({		
		url:url+'?action=getMedEduRecord',	
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
	
	find_medEduGrid(stDate,endDate);
}

/// ��ӡ��Ժ��ҩ����
function printMedEducation()
{
	var medEduOutID=$('#OutRowId').val();
	print_medEducation(medEduOutID);
}

/// ��ӡ��Ժ��ҩ����
function printMedEducationIN()
{
	var medEduInID=$('#InPatEduRid').val();
	print_medEducationIN(medEduInID);
}
/// ��ӡ����Ժ��ҩ����
function printMedEducationNew()
{
	print_medEducationNew(EpisodeID);
}
/// ��ӡȫ����ҩ����
function printMedEducationAll(){
	PRINTCOM.jsRunServer(
	{
		ClassName: 'web.DHCPHMEDEDUCATION',
		MethodName: 'GetMedEducationIdS',
		admId: EpisodeID
	},
	function(retJson){
		if($.isEmptyObject(retJson)){
			$.messager.alert("��ʾ","û����ҩ������¼��");
			return;	
		}else{
			$.each(retJson, function(k, v){
				if(!v.Id){
					return true;	
				}
				if(v.status == "N"){
					print_medEducationNew(EpisodeID);	
				}else if(v.status == "I"){
					print_medEducationIN(v.Id);
				}else if(v.status == "O"){
					print_medEducation(v.Id);
				}	
			})	
		}
	})
}
      /// ��ʼ����Ժָ����Χ add  by yuliping
function InitGuiScopeTableEDU(){
	
	//��ȡ���ڵ�
	/* var rtn=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
		{
			'ModType':"EDU",
			'SubModType':"N",
			'PatCode':""
	     }); */
	var rtn=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","EDU","N","");
	var htmlStr=""
	if(rtn==""){
		//���ڵ�Ϊ�գ���ʾ��Ϣ
		 htmlStr= htmlStr+"<tr style='padding:2px;height:30px;'><td style='margin-left:10px;color:red'>��ά���ֵ�!</td>"
		}else{
		htmlStr= htmlStr+"<tr style='margin:4px;height:30px;'>";
		var flag=0;
		var rtnArr=rtn.split("!");
		for(var i=0;i<rtnArr.length;i++){
			var rtnArrs=rtnArr[i].split("^");
			htmlStr= htmlStr+"<td style='width:210px;'><span style='margin-left:10px;'><input value="+rtnArrs[2]+" type='checkbox' name='GuiContent' class='GuiScope'></input><span>"+ rtnArrs[1]+"</span></span></td>";
			flag+=1;
			if((flag%3)==0)
			{
				htmlStr= htmlStr+"</tr><tr style='margin:4px;'>";
				}
			}
			htmlStr= htmlStr+"</tr>";
		}
		htmlStr= htmlStr+"</tr>";
		//alert(htmlStr)
		$("#EDUN").append(htmlStr);
	}
/// ��ʼ��סԺָ����Χ add  by yuliping
function InitGuiScopeTableEDUI(){
	
	//��ȡ���ڵ�
	/*var rtn=serverCall('web.DHCSTPHCMGuiScope','getGuiScopePatCode',
		{
			'ModType':"EDU",
			'SubModType':"I",
			'PatCode':""
	     });*/
	var rtn=tkMakeServerCall("web.DHCSTPHCMGuiScope","getGuiScopePatCode","EDU","I","");
	var htmlStr=""
	if(rtn==""){
		//���ڵ�Ϊ�գ���ʾ��Ϣ
		 htmlStr= htmlStr+"<tr style='padding:2px;height:30px;'><td style='margin-left:10px;color:red'>��ά���ֵ�!</td>"
		}else{
		htmlStr= htmlStr+"<tr style='margin:4px;height:30px;'>";
		var flag=0;
		var rtnArr=rtn.split("!");
		for(var i=0;i<rtnArr.length;i++){
			var rtnArrs=rtnArr[i].split("^");
			htmlStr= htmlStr+"<td style='width:170px;'><span style='margin-left:10px;'><input value="+rtnArrs[2]+" type='checkbox' name='InGuiContent' class='GuiScope'></input><span>"+ rtnArrs[1]+"</span></span></td>";
			flag+=1;
			if((flag%4)==0)
			{
				htmlStr= htmlStr+"</tr><tr style='margin:4px;'>";
				}
			}
			htmlStr= htmlStr+"</tr>";
		}
		htmlStr= htmlStr+"</tr>";
		$("#EDUI").append(htmlStr);
	}
