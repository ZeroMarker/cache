/*
* ҽѧ�鷿
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;">ҩѧ��ע��<span style="color:red;">[˫���м��ɱ༭]</span></span>';
var EpisodeID=""
//var PatientID="";
//var AdmLocID="";
//PatientID=getParam("PatientID");	
//AdmLocID=getParam("AdmLocID"); 
$(document).ready(function(){
	
	EpisodeID=getParam("EpisodeID");
	
	InitPatientInfo(EpisodeID);		
	var rowid=$('#RowId').val();		/// �״β鷿ID  qunianepng 2018/3/10
	var  panelTitle = "";	
	if(rowid == ""){					/// �״β鷿�Ѿ���д������Ĭ�ϴ��ճ��鷿������Ĭ�ϴ��״β鷿
		 panelTitle = "�״β鷿��¼";	
		 $('.easyui-accordion ul li a:contains("�״β鷿��¼")').css({"background":"#87CEFA"});
	}
	else{
		 panelTitle = "�ճ��鷿��¼";
		 $('.easyui-accordion ul li a:contains("�ճ��鷿��¼")').css({"background":"#87CEFA"});	
		
	}
	choseMenu(panelTitle);
	//���ݵ����ϸ��ʾ����panel
	$('.easyui-accordion ul li a').click(function(){
		$('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		$(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //�����˵�����ʾ��Ӧ����
		 choseMenu(panelTitle);
	});
	
	var arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
	EpisodeID=arrSource[1].split("=")[1];	
	pageBasicControll();	
	initDataDG();	
	getPatObserInfo(EpisodeID);  //�Զ����ò�����������
})


function choseMenu(item){
	switch(item){
		case "�״β鷿��¼":
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
			
		case "�ճ��鷿��¼":
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
			
		default:
			break;	
	}
				 	
} 

//--����"�״β鷿��¼"������--//
var Flag1=0;//��ֹ�ظ��������δ������
function createPanel() {
	if(Flag1==0){
		//����ʾ��ѯ������
		$("#content1").css("display","block");
		Flag1=1;
		Flag2=0;
		InitPatientInfo(EpisodeID);	
	}
	InitNewPagePatInfo(EpisodeID)
}
function InitNewPagePatInfo(EpisodeID)
{ 
    if(EpisodeID==""){return;}
    $.ajax({
   				type: "POST",
   				url: url,
   				data:{action:'GetPatInfo',AdmDr:EpisodeID}, 
	        	success: function(val){ 
	        	if(val!=""){
		  	     var tmps=val.split("^");
		   		 $('#PatSex').val(tmps[2]);    		/// �Ա�
     		     $('#PatName').val(tmps[1]);    	/// ����
     		     $('#PatBed').val(tmps[4]);    		/// ����
     		     $('#PatMedRec').val(tmps[0]);    	/// �ǼǺ�
	   		     $('#PatAge').val(tmps[3]);        ///���� 
	   		     $('#PatPayType').val(tmps[6]);        ///�ѱ�
	        	}			
   	  		}		
   		});

}
function InitPatientInfo(){
  if(EpisodeID==""){return;}
	
   var cliPatID="";
   
   //��ȡ����Ժ���߲鷿��¼��Ϣ
   $.ajax({
   	   type: "POST",
  	   url: url,
   	   data: "action=getMedWardInf&AdmDr="+EpisodeID+"&Status="+"First",
       //dataType: "json",
	   async:false,
       success: function(val){
	       var obj = eval( "(" + val + ")" );
	       if(obj.total==0){
		      //���û���״β鷿��¼
		      //1.��ȡ���˻�����Ϣ�����������Ϣ
   			  $.ajax({
   				type: "POST",
   				url: url,
   				data:{action:'GetPatEssInfo',EpisodeID:EpisodeID}, //nisijia 2016-09-08
   				//dataType: "json",
   				 //dataType: "json",
	        	success: function(jsonString){ 
	     		var adrRepObj = jQuery.parseJSON(jsonString);
		   		 $('#AdmInf').val(adrRepObj.patdiag);    //���		
   	  			}		
   			  });
   			  
   			  //2. �״β鷿���棬������ҩ��Ϣ(�������Ժ����
              //   ҽѧ�鷿��¼������ҩ��Ϣ����ֱ�Ӽ���)
              var wardRoundID="";
   			  //��ȡ����Ժ���߲鷿��¼��Ϣ
   			  $.ajax({
   	   			type: "POST",
  	   			url: url,
   	   			data: "action=getPatWardInf&AdmDr="+EpisodeID+"&Status="+"New",
       			//dataType: "json",
       			success: function(val){
	      
	      			if(val!=-999){
		  				var tmps=val.split("!");
		  				var listMain=tmps[0].split("^"); //����Ϣ
		  
		  				//��ȡ�鷿��¼ID�����id�����ڣ����޲鷿��¼���򲻼���ҩƷ��Ϣ�б�
		  				wardRoundID=tmps[8];
						if(wardRoundID!=""){
							$.ajax({
   	   							type: "POST",
  	   							url: url,
   	   							data: "action=getWRDrgItm&wardRoundID="+wardRoundID,
      			 				//dataType: "json",
       							success: function(val){
	       							var obj = eval( "(" + val + ")" );
	       							//ֻ�е�����ֵ�����ݣ��ż���
	       							if(obj.total!=0){
	       								$('#drugdg').datagrid('loadData',obj);
	       							}	       				
       							}
							});							
			 			  }			 
	      			  }	      
       			  }            
			  });
			//����
			//var ChiefComplaint=tkMakeServerCall("web.DHCSTPHCMCOMMON","getPatPriAct",EpisodeID); qunianpeng ���ߴӵ��Ӳ���ȡ2018/3/13			
			var patInfo=tkMakeServerCall("web.DHCSTPHCMCOMMON","GetPatInfoByEmr",EpisodeID);
			var ChiefComplaint=patInfo.split("@");
			$('#ChiefComplaint').val(ChiefComplaint[0]);
			  
		   }else{
		   	   //�Ѿ��������״�ҽѧ�鷿��¼
		   	   var arrayJson=obj.rows;
		   	   arrayJson=arrayJson[0];//��Ϊֻ��һ����¼
		   	   //------�Խ���������ݸ�ֵ
	           $('#Temperature').val(arrayJson.Temperature);//����
	           $('#Pulse').val(arrayJson.Pulse);//����
	           $('#Breath').val(arrayJson.Breath);//����
	           $('#Heartrate').val(arrayJson.Heartrate);//����
	           $('#Bloodpre').val(arrayJson.Bloodpre);//Ѫѹ
	           $('#Urineamt').val(arrayJson.Urineamt);//����
	           //1��˫�κ�����
	           $("input[type='checkbox'][name='DouLunBrePho']").each(function(){
					if($(this).val()==arrayJson.DouLunBrePho && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);    //��ʼ����ѡ���ѡ��״̬)(1-8)  sufan  2016/09/18
						//$(this).toggleClass('cb_active');
			   		}
			   });
	                   
			   //2������
    		   $("input[type='checkbox'][name='Rale']").each(function(){
					if($(this).val()==arrayJson.Rale && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			  //3������
			  $("input[type='checkbox'][name='Arrhythmia']").each(function(){
					if($(this).val()==arrayJson.Arrhythmia && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
	         //4������Ĥ������������������
	         $("input[type='checkbox'][name='PathMurmur']").each(function(){
					if($(this).val()==arrayJson.PathMurmur && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			 //5������
			 $("input[type='checkbox'][name='Belly']").each(function(){
					if($(this).val()==arrayJson.Belly && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			 //6����Ƣ����
			 $("input[type='checkbox'][name='LivLieCos']").each(function(){
					if($(this).val()==arrayJson.LivLieCos && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
	         //7��˫����ߵ��ʹ
	         $("input[type='checkbox'][name='PerPain']").each(function(){
					if($(this).val()==arrayJson.PerPain && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
	
			  //8��˫��֫ˮ��
			  $("input[type='checkbox'][name='Oedema']").each(function(){
					if($(this).val()==arrayJson.Oedema && !$(this).hasClass('cb_active')){
						$(this).attr("checked",true);
						//$(this).toggleClass('cb_active');
			   		}
			  });
			  
	          //9��ָ������
	          $('#FirstMedWardGuideContent').val(arrayJson.Guidance);
	           var maxlimit=800;
		       if ($('#FirstMedWardGuideContent').val().length >maxlimit){  
                   $('#FirstMedWardGuideContent').val(($('#FirstMedWardGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen"]').val(maxlimit-$('#FirstMedWardGuideContent').val().length);
		       }
			  
			  //10.�״β鷿��¼ID
			  $('#RowId').val(arrayJson.PHCPRid);
			  
			  //11�����
			  $('#AdmInf').val(arrayJson.Icd);
			  
			  //12��ҩƷ�б�
			  var cliPatID=$('#RowId').val();
			  $.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getMRDrgItm&cliPatID="+cliPatID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				$('#drugdg').datagrid('loadData',obj);
       				}
			  });
			  
			  //13������
			  $.ajax({
   	   				type: "POST",
  	   				url: url,
   	   				data: "action=getChiefComtItm&cliPatID="+cliPatID,
      			 	//dataType: "json",
       				success: function(val){
	       				var obj = eval( "(" + val + ")" );
	       				var arrayJson=obj.rows;
	       				var ChiefComt="";
	       				for(var i=0;i<arrayJson.length;i++){
		       				
		       				ChiefComt+="||"+arrayJson[i].preComText
		       			}
		       			ChiefComt=ChiefComt.substring(2,ChiefComt.length);
		       			$('#ChiefComplaint').val(ChiefComt);
       				}
			  });	     
		   }		   
       }       
    });  
  
}

//--����"�鷿��¼"������--//
var Flag2=0;//��ֹ�ظ��������δ������
function createInHopPanel(){
	if(Flag2==0){
		//����ʾ��ѯ������
		$("#content2").css("display","block");
		Flag2=1;
		Flag1=0;
	}
	InitPagePatInfo(EpisodeID)
}
function InitPagePatInfo(EpisodeID)
{ 
    if(EpisodeID==""){return;}
    $.ajax({
   				type: "POST",
   				url: url,
   				data:{action:'GetPatInfo',AdmDr:EpisodeID}, 
	        	success: function(val){ 
	        	if(val!=""){
		  	     var tmps=val.split("^");
		   		 $('#InPatSex').val(tmps[2]);    		/// �Ա�
     		     $('#InPatName').val(tmps[1]);    	/// ����
     		     $('#InPatBed').val(tmps[4]);    		/// ����
     		     $('#InPatMedRec').val(tmps[0]);    	/// �ǼǺ�
	   		     $('#InPatAge').val(tmps[3]);        ///���� 
	   		     $('#InPatPayType').val(tmps[6]);        ///�ѱ�
	        	}			
   	  		}		
   			  });

}
/**
* �����ϻ������ݵ���ʾ����
* 
* 1.ÿ������"�༭����.."����ȡ���㡢ʧȥ���㣬���ݿ���
*/
function pageBasicControll(){
	
	//��ѡ��ť�¼�
	$("input[type='checkbox']").each(function(){
		$(this).click(function(){
			$(this).toggleClass('cb_active');
		});
	});
	
	//��ѡ�����
	InitUIStatus();
	
	/*�״β鷿*/
	$('#FirstMedWardGuideContent').focus(function(){
		if($(this).text()=="�༭����.."){
			$(this).text("");
		}
	})
	$('#FirstMedWardGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("�༭����..");
		}
	})
	
	/*�鷿��¼*/
	$('#MedWardGuideContent').focus(function(){
		if($(this).text()=="�༭����.."){
			$(this).text("");
		}
	})
	$('#MedWardGuideContent').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("�༭����..");
		}
	})
}


///��ʼ�����渴ѡ���¼�
function InitUIStatus()
{
	var tmpid="";
	$("input[type='checkbox']").click(function(){   //sufan 2016/09/18
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}

//��ʼ������datagrid��ʾ
function initDataDG(){
	/*
	//����columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
	    {field:'incidesc',title:'��Ʒ����',width:300,align:'left'},
	    {field:'genenic',title:'ͨ����',width:300,align:'left'},
	    {field:'manf',title:'������ҵ',width:300,align:'left'},
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
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//�к� 
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
	$('#drugdatagrid').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//�к� 
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            $("#drugdatagrid").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	InitdatagridRow();
	*/
}

/// ����
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

// ɾ����
function delRow(datagID,rowIndex)
{
	//�ж���
    var rowobj={
		orditm:'', incidesc:'', genenic:'', manf:''
	};
	
	//��ǰ��������4,��ɾ�����������
	var selItem=$('#'+datagID).datagrid('getSelected');
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
		height:520
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
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:'����',width:280},
		{field:'genenic',title:'ͨ����',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'����',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'Ƶ��',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'�Ƴ�',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'��׼�ĺ�',width:80},
		{field:'manf',title:'����',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'����',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	
	//����datagrid
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		queryParams:{
			params:EpisodeID
		}
	});	
}

function addWatchDrg(){
	if(Flag1==1){
		var medWardRid=$('#RowId').val();
		//�״β鷿��¼
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
		/**
		*1.�����ʼ�鷿��¼rowid�����ڣ���ҩƷ�б���ʾΪ��ʼ��Ŀ
		*2.����鷿��¼rowid���ڣ�����ݹ�עҩƷ����datagrid��ʾ��ͨ��reload��ʽ
		*/
		if(medWardRid==""){
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg'
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
    	}else{
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg'
				}
				$("#drugdg").datagrid('appendRow',rowobj);
	   		});
	    }
    	//$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}else if(Flag2==1){
		//�鷿��¼
		//��ҩ�б�
		var medWardRid=$('#MedPhaRid').val();
		var rows = $('#drugdatagrid').datagrid('getRows');
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
		/**
		*1.�����ʼ�鷿��¼rowid�����ڣ���ҩƷ�б���ʾΪ��ʼ��Ŀ
		*2.����鷿��¼rowid���ڣ�����ݹ�עҩƷ����datagrid��ʾ��ͨ��reload��ʽ
		*/
		if(medWardRid==""){
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdatagrid'
				}
	    		if(k>3){
					$("#drugdatagrid").datagrid('appendRow',rowobj);
				}else{
					$("#drugdatagrid").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
						index: k, // ������0��ʼ����
						row: rowobj
					});
				}
				k=k+1;
    		})
    	}else{
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdatagrid'
				}
				$("#drugdatagrid").datagrid('appendRow',rowobj);
	   		});
	    }
    	//$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
		
	}
  $('#mwin').window('close');
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

//��ʼ���б�ʹ��
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:''}
		});
		
		$("#drugdatagrid").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',genenicdr:'',manf:'',manfdr:'',form:'',formdr:'',spec:''}
		});
		
	}
}

//�����״β鷿��¼
function saveFirstMedRoundInf(){
	//0.��������Ϣ
	var Temperature=$('#Temperature').val();/// ����
	var Pulse=$('#Pulse').val();			/// ����
	var Breath=$('#Breath').val();			/// ����
	var Heartrate=$('#Heartrate').val();	/// ����
	var Bloodpre=$('#Bloodpre').val();		/// Ѫѹ
	var Urineamt=$('#Urineamt').val();		/// ����
	if ((Temperature=="")||(Pulse=="")||(Breath=="")||(Heartrate=="")||(Bloodpre=="")||(Urineamt=="")){//sufan 2016/9/13
		$.messager.alert("��ʾ","��¼������������������!");
		return;
		}
	//1��˫�κ�����
	var DouLunBrePho="";
    $("input[type='checkbox'][name='DouLunBrePho']").each(function(){
	    if($(this).is(':checked')){  		/// �״β鷿����,����ѡ���ֵ�ı�ʱ,����ʱ��ȡֵ(1-8)  sufan 2016/09/18
		//if($(this).hasClass('cb_active')){
		DouLunBrePho=this.value;     		/// ȡѡ����ֵ  qunianpeng 2016-09-14 �����״μ�¼ȡֵ����
		}
	})
	if(DouLunBrePho==""){
		$.messager.alert("��ʾ:","˫�κ���������Ϊ�գ�");
		return;
	}
	//2������
	var Rale="";
    $("input[type='checkbox'][name='Rale']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Rale=this.value;		
		}
	})
	if(Rale==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�");
		return;
	}
	//3������
	var Arrhythmia="";
    $("input[type='checkbox'][name='Arrhythmia']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Arrhythmia=this.value; 
		}
	})
	if(Arrhythmia==""){
		$.messager.alert("��ʾ:","���ɲ���Ϊ�գ�");
		return;
	}
	//4������Ĥ������������������
	var PathMurmur="";
    $("input[type='checkbox'][name='PathMurmur']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			PathMurmur=this.value;		
		}
	})
	if(PathMurmur==""){
		$.messager.alert("��ʾ:","����Ĥ����������������������Ϊ�գ�");
		return;
	}
	//5������
	var Belly="";
    $("input[type='checkbox'][name='Belly']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Belly=this.value;		
		}
	})
	if(Belly==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�");
		return;
	}
	//6����Ƣ����
	var LivLieCos="";
    $("input[type='checkbox'][name='LivLieCos']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			LivLieCos=this.value;		
		}
	})
	if(LivLieCos==""){
		$.messager.alert("��ʾ:","��Ƣ���²���Ϊ�գ�");
		return;
	}
	//7��˫����ߵ��ʹ
	var PerPain="";
    $("input[type='checkbox'][name='PerPain']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			PerPain=this.value;		
		}
	})
	if(PerPain==""){
		$.messager.alert("��ʾ:","˫����ߵ��ʹ����Ϊ�գ�");
		return;
	}
	//8��˫��֫ˮ��
	var Oedema="";
    $("input[type='checkbox'][name='Oedema']").each(function(){
	    if($(this).is(':checked')){
		//if($(this).hasClass('cb_active')){
			Oedema=this.value;		
		}
	})
	if(Oedema==""){
		$.messager.alert("��ʾ:","˫��֫ˮ�ײ���Ϊ�գ�");
		return;
	}
	
	//9.ָ������
	var Guidance=$('#FirstMedWardGuideContent').val();
	if(Guidance=="�༭����.."){			/// qunianpeng 2017/11/22 ��ֹδ�������ݣ�������Ĭ������
		Guidance=""	
	}
	
	
	//10.�״β鷿��¼ID
	var rowid=$('#RowId').val();
	
	
	//��Ҫ����仯
	var ChaOfDisDesc="";
	
	//��¼��
	var UserDr=session['LOGON.USERID'];
	
	//���
	var Icd=$('#AdmInf').val();
	
	//---��Ҫ��¼��Ϣ
	var cpMasDataList=EpisodeID+"^"+Temperature+"^"+Pulse+"^"+Breath+"^"+Heartrate+"^"+Bloodpre+"^"+Urineamt ;
	cpMasDataList=cpMasDataList+"^"+DouLunBrePho+"^"+Rale+"^"+Arrhythmia+"^"+PathMurmur+"^"+Belly+"^"+LivLieCos;
	cpMasDataList=cpMasDataList+"^"+PerPain+"^"+Oedema+"^"+ChaOfDisDesc+"^"+Guidance+"^"+UserDr+"^"+Icd;
	
	//----����
	var PreComList=$('#ChiefComplaint').val().trim();
		if(PreComList==""){
		$.messager.alert("��ʾ:","���߲���Ϊ�գ�");
		return;
	}
	
	//----��עҩƷ�б�
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	var input=cpMasDataList+"!"+PreComList+"!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=SaveMedWardRoundInf',//�ύ������  
		data: "rowid="+rowid+"&"+"input="+input,//�ύ�Ĳ���    //sufan 2016/09/18(�޸�rowid)
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

//����鷿��¼
function saveMedRoundInf(){
        //liubeibei 20180626  ��д�״β鷿��¼��ſ���д�ճ��鷿��¼
        var firstRowid=tkMakeServerCall("web.DHCPHCLIPATHOGRAPHY","getMedWardRoundID",EpisodeID,"First");
        if(firstRowid==0)
        {
             $.messager.alert("��ʾ","������д�״β鷿��¼!");
             return;
        }
	//0.��������Ϣ
	var Temperature=$('#Temperature1').val();/// ����
	var Pulse=$('#Pulse1').val();			/// ����
	var Breath=$('#Breath1').val();			/// ����
	var Heartrate=$('#Heartrate1').val();	/// ����
	var Bloodpre=$('#Bloodpre1').val();		/// Ѫѹ
	var Urineamt=$('#Urineamt1').val();		/// ����
	if ((Temperature=="")||(Pulse=="")||(Breath=="")||(Heartrate=="")||(Bloodpre=="")||(Urineamt=="")){//sufan 2016/9/13
		$.messager.alert("��ʾ","��¼������������������!");
		return;
		}
	//1��˫�κ�����
	var DouLunBrePho="";
   
	//2������
	var Rale="";
   
	//3������
	var Arrhythmia="";
   
	//4������Ĥ������������������
	var PathMurmur="";
   
	//5������
	var Belly="";
  
	//6����Ƣ����
	var LivLieCos="";
   
	//7��˫����ߵ��ʹ
	var PerPain="";
   
	//8��˫��֫ˮ��
	var Oedema="";
  	
	//9.ָ������
	var Guidance=$('#MedWardGuideContent').val();
	if ((Guidance=="")||(Guidance=="�༭����..")){   //sufan 2016/09/18
		$.messager.alert("��ʾ","��¼������,���������룡");
		return;
		}
	//10.�״β鷿��¼ID
	var rowid=$('#MedPhaRid').val();

	//��Ҫ����仯
	var ChaOfDisDesc=$('#ChaOfDisDesc').val();
	if(ChaOfDisDesc==""){
		$.messager.alert("��ʾ","��¼�����������������룡");   //sufan 2016/09/13
		return;
		}
	//��¼��
	var UserDr=session['LOGON.USERID'];
	
	//���
	var Icd="";
	
	//---��Ҫ��¼��Ϣ
	var cpMasDataList=EpisodeID+"^"+Temperature+"^"+Pulse+"^"+Breath+"^"+Heartrate+"^"+Bloodpre+"^"+Urineamt ;
	cpMasDataList=cpMasDataList+"^"+DouLunBrePho+"^"+Rale+"^"+Arrhythmia+"^"+PathMurmur+"^"+Belly+"^"+LivLieCos;
	cpMasDataList=cpMasDataList+"^"+PerPain+"^"+Oedema+"^"+ChaOfDisDesc+"^"+Guidance+"^"+UserDr+"^"+Icd;
	
	//----����
	var PreComList="";
	
	//----��עҩƷ�б�
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdatagrid').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	var input=cpMasDataList+"!"+PreComList+"!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',							/// �ύ��ʽ post ����get  
		url: url+'?action=SaveMedWardRoundInf', /// �ύ������  
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

function clearData(){
	window.location.reload();
}

function query(){
	 $('#recordWin').window({
		title:'ҽѧ�鷿��¼',
		collapsible:true,
		border:false,
		closed:"true",
		width:800,
		height:400,
		minimizable:false						/// ������С����ť(qunianpeng 2018/3/15)
		//maximized:true						/// ���

	}); 

	$('#recordWin').window('open');
	//��ֹʱ��
	$("#startDate").datebox("setValue", formatDate(-1));
	$("#endDate").datebox("setValue", formatDate(0));
	
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_medWardGrid(stDate,endDate);
}


//���˵�סԺ�ڼ�鷿��¼�б�
function find_medWardGrid(stDate,endDate)
{
	
	//����columns
	var columns=[[
		{field:"PHCPRid",title:'RowID',width:100},
		{field:'recordDate',title:'��¼����',width:200},
		{field:'User',title:'��¼��',width:200}
	]];
	
	//����datagrid
	$('#medWardRecord').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  				/// ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   		/// ��������ÿҳ��¼�������б�
	    	singleSelect:true,     	/// nisijia 2016-09-23
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function() { 
    		var selected = $('#medWardRecord').datagrid('getSelected'); 
    		if (selected){ 
      			//alert(selected.incirowid); 
      			$('#recordWin').window('close');
 		     	/*��ȡ��¼ID*/
				$('#MedPhaRid').val(selected.PHCPRid);
				//����������Ϣ
				$('#Temperature1').val(selected.Temperature);	/// ����
				$('#Pulse1').val(selected.Pulse);				/// ����
				$('#Breath1').val(selected.Breath);				/// ����
				$('#Heartrate1').val(selected.Heartrate);		/// ����
				$('#Bloodpre1').val(selected.Bloodpre);			/// Ѫѹ
				$('#Urineamt1').val(selected.Urineamt);			/// ����
				$('#ChaOfDisDesc').val(selected.ChaOfDisDesc);  /// ��Ҫ����仯���
				$('#MedWardGuideContent').val(selected.Guidance);
					 var maxlimit=800;
		       if ($('#MedWardGuideContent').val().length >maxlimit){  
                   $('#MedWardGuideContent').val(($('#MedWardGuideContent').val().substring(0, maxlimit))); 
		       }else{ 
                 $('input[name="remLen1"]').val(maxlimit-$('#MedWardGuideContent').val().length);
		       }
				//��ȡ�鷿��¼ID�����id�����ڣ����޲鷿��¼���򲻼���ҩƷ��Ϣ�б�
		  		var cliPatID=$('#MedPhaRid').val();
				if(cliPatID!=""){	
					/*������ҩ��Ϣ*/
					$.ajax({
   	   					type: "POST",
  	   					url: url,
   	   					data: "action=getMRDrgItm&cliPatID="+cliPatID,
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
	
	$('#medWardRecord').datagrid({
		url:url+'?action=GetMedWardRecord',	
		queryParams:{
			AdmDr:EpisodeID,
			startDate:stDate,
			endDate:endDate	
		}
	});
}

function queryByDate(){
	var stDate=$('#startDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
	
	find_medWardGrid(stDate,endDate);
}

/// ���µ� bianshuai 2015-01-20
function getPatObserInfo(EpisodeID)
{
	$.ajax({
		type: "POST",
		url: url,
		data: "action=GetPatVitalSigns&EpisodeID="+EpisodeID,
		//dataType: "json",
		success: function(str){
			if(str.replace(/(^\s*)|(\s*$)/g,"")==""){return;}
			var vSObj = eval('('+str+')');
			//������������[�״β鷿]
			$("input[name=VitalSigns]").each(function(){
				var tempstr=$(this).parent().html().replace('<SPAN class=star>*</SPAN>',"");
				var obserdesc=tempstr.substring(0,2).replace(/(^\s*)|(\s*$)/g,"");					
				if(typeof vSObj[obserdesc]!="undefined"){
					$(this).val(vSObj[obserdesc]); //��ֵ
				}
				/*
				if(typeof vitalSignsObj[this.id]!=undefined){
					$('#'+this.id).val(vitalSignsObj[this.id]);
				}
				*/
			});
			
			//������������[�ճ��鷿]
			$("input[name=VitalSigns1]").each(function(){
				var tempstr=$(this).parent().html().replace('<SPAN class=star>*</SPAN>',"");
				var obserdesc=tempstr.substring(0,2).replace(/(^\s*)|(\s*$)/g,"");
				if(typeof vSObj[obserdesc]!="undefined"){
					$(this).val(vSObj[obserdesc]); //��ֵ
				}
				/*
				var property=this.id.substring(0,this.id.length-1)
				if(typeof vitalSignsObj[property]!=undefined){
					$('#'+this.id).val(vitalSignsObj[property]);
				}
				*/
			});
		}
	});

}

/// ��ӡҽѧ�״β鷿��¼
function printFirstMedRoundInf(){
	var medWardID=$('#RowId').val();
	print_FirstMedRoundInf(medWardID);
}


/// ��ӡҽѧ�ճ��鷿��¼
function printMedRoundInf(){
	var medWardID=$('#MedPhaRid').val();
	print_MedRoundInf(medWardID);
}

function printMedRoundInfAll(){
	var phchStr = tkMakeServerCall("web.DHCPHCLIPATHOGRAPHY","GetPhcpIdStr",EpisodeID)
	if(phchStr == ""){
		$.messager.alert("��ʾ","û��ҽѧ�鷿��¼��");
		return;
	}
	var phcpIdArr = phchStr.split("^");
	for(var i in phcpIdArr){
		if(!phcpIdArr[i]){
			continue;	
		}
		if(i == 0){
			print_FirstMedRoundInf(phcpIdArr[i]);
		}else{
			print_MedRoundInf(phcpIdArr[i]);
		}	
	}
}