 
 /// ҩѧ�໤�༭
 var url="dhcpha.clinical.action.csp";
 var monLevId="";  //�໤����
 var monLevelDesc="" //�໤��������
 var monAdmID="";
 var monSubClassId=""; //ѧ�Ʒ���
 var monId="";         //�໤ID
 var monIndex="";
 var NOW_TREE_SELECT_ID = "";
 $(function(){
	 monAdmID=getParam("monAdmID");
	 monSubClassId=getParam("monSubClassId");
	 monLevelDesc=getParam("monLevelDesc");
	 monLevelDesc=unescape(monLevelDesc)
	 if(monLevelDesc.indexOf("@")){
		monLevelDesc = "<font color="+ monLevelDesc.split("@")[1] +">"+monLevelDesc.split("@")[0]+"</font>"; 
	 }
	 LoadPatMonList();
 	 InitUI();
 	 $('a:contains("����")').bind("click",save);  //�ύ
 })
 
 function InitUI(){
	$('#ImpMonItems').bind("focus",function(){
		if(this.value=="�༭����..."){
			$('#ImpMonItems').val("");
		}
	});
	
	$('#ImpMonItems').bind("blur",function(){
		if(this.value==""){
			$('#ImpMonItems').val("�༭����...");
		}
	});
	
	$('#ImpMonContent').bind("focus",function(){
		if(this.value=="�༭����..."){
			$('#ImpMonContent').val("");
		}
	});
	
	$('#ImpMonContent').bind("blur",function(){
		if(this.value==""){
			$('#ImpMonContent').val("�༭����...");
		}
	});
 }

 /// ���ü໤����ע��
 function setMonItem(note){
     note = "[����һ�Ϊ"+ note +"]";
	 $('span.ui-font12:contains("����")').html(note);	 
 }
 /// ���ؼ໤��Χ
 function LoadMonScope(){
	 $.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=getMonScopeList',//�ύ������ �����ķ���  
		data: {monSubClassId:monSubClassId, monLevId:monLevId}, //�ύ�Ĳ���  
		success:function(jsonString){
			createLevScope(jsonString);      
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	}); 
 }
 
 /// ���ؼ໤��Ŀ
 function LoadMonItem(){
	 createLevItm(monSubClassId); 
 }
 
 /// ����ָ��Ͳ���ת�����
 function LoadMonImpLabsAndGuidCon(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=getMonImpLabsAndGuidCon',
		data: {monId:monId},
		success:function(jsonString){
			var monImpLabsAndGuidConObj = jQuery.parseJSON(jsonString);
	     	$('#ImpMonItems').val(monImpLabsAndGuidConObj[0].ImpMonItems);
	     	$('#ImpMonContent').val(monImpLabsAndGuidConObj[0].ImpMonContent);
			textCounterNew();
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	});
 }
 
 ///  ��̬���ؼ໤��Χ�����б�
 function createLevScope(jsonString){
	 var mLevScopeListObj = jQuery.parseJSON(jsonString);
	 var tmpArr=[];
     var htmlls = '<div><table>';
     for(var i=0;i<mLevScopeListObj.length;i++){
	    var extFlag=0;
	    for(var n = 0;n < tmpArr.length; n++){
		    if(tmpArr[n] == mLevScopeListObj[i].PHMSCRowID){
			    extFlag=1;
			}
		}
		if (extFlag==0) {	  //���ظ�������ͬ��ѧ�Ʒ���
			tmpArr.push(mLevScopeListObj[i].PHMSCRowID);	
			htmlls += '<tr>';		//����ѧ�Ʒ���
			htmlls += '<td><input id="'+mLevScopeListObj[i].PHMSCRowID+'" class="cb" type="checkbox" name="CheckBoxMain" />'+mLevScopeListObj[i].PHMSCDesc+' </td>';     	
			htmlls += ' </tr>';
		} 
		htmlls += '<tr style=" class="'+mLevScopeListObj[i].PHMSCRowID+'">';				//���������׼
		htmlls += '<td><input type="checkbox" class="cb" style="margin-left:40px" name="'+mLevScopeListObj[i].monScopeID+'" />'+mLevScopeListObj[i].monScopeDesc+'</td>';     	
		htmlls += '</tr>';	
	 }
	 htmlls += "</table></div>";
	 $('#m_LevScope').append(htmlls);  
     $("div[id='mainpanel']").css('overflow','auto');  //��������������Զ���������
     LoadPatMonScopeList();
     LoadPatMonItemList();
     LoadMonImpLabsAndGuidCon();
 }

 ///��̬���ؼ໤��Ŀ�����б�
  function createLevItm(monSubClassId){  
	   runClassMethod("web.DHCSTPHCMPHARCAREMAIN","GetScopeDescList",{"classId":monSubClassId},function(jsonString){	
	 	if (jsonString != ""){		
			$.each(jsonString,function(index,obj){
				var htmls = "";
				 htmls = htmls + '<div> <input id="'+obj.classDesc+'" class="cblevel" type="checkbox" name="CheckBoxClass" />'+obj.classDesc+' ';  
				 runClassMethod("web.DHCSTPHCMPHARCAREMAIN","getMonItemListNew",{"classId":obj.classId,"monLevelId":monLevId},function(jsonObj){			
					if (jsonObj != ""){
						htmls = htmls + '<table style="margin-left:20px; ">';
						var $td = 'width:30%;';
						var spanleft  = 'margin-left:10px; margin-right:5px;';
	 					var spanright = 'margin-left:5px;  margin-right:100px;';
	 					var subhtmls = ""	 	 					
	 					$.each(jsonObj,function(subindex,subobj){	
	 						if((subindex+1)%3 == 1){  
						     	subhtmls = subhtmls + '<tr>';
					     	 }
					     	 subhtmls = subhtmls + '<td style="'+$td+'" ><span style="'+spanleft+'">'+subobj.monItemDesc+'</span><input type="text" name="'+subobj.monItemID+'" class="input-ui-width"/><span style="'+spanright+'" >'+subobj.monItemUom+'</span> </td>';						    
						     if((subindex+1)%3 == 0){
						     	subhtmls = subhtmls + '</tr>';
						     }						     
						});					
						htmls = htmls + subhtmls;
					}
				 },'json',false)					
				
				htmls = htmls + "</table></div>";
				$('#m_LevItem').append(htmls);									
			});
		}
		else{
			alert("��ȡ����ʧ��!");
		}
	 },'json',false)  
			
 }	  
  
/// ���ز��˼໤�б�
function LoadPatMonList(){
	$('#m_PatMonList').treegrid({
		idField:'id', 
	    treeField:'text',
	    fit:true,
	    url: url+'?action=getPatMonList&monLevId='+monLevId+'&AdmDr='+monAdmID,
	    columns:[[    
	        {title:'id',field:'id',width:80,hidden:true},    
	        {field:'text',title:'�໤����',width:250},
	        {field:'monLevId',title:'monLevId',hidden:true},
	        {field:'monId',title:'monId',hidden:true},
	        {field:'_parentId',title:'parentId',hidden:true}
	    ]],
	    onSelect: function(row){
		    if(!(row.id>0)){
			    $(this).treegrid('select', NOW_TREE_SELECT_ID);
			    return;
			}
			if(NOW_TREE_SELECT_ID === row.id){
				return;
			}
		    NOW_TREE_SELECT_ID = row.id;
		    monLevId = row.monLevId;
		 	monId = row.monId;
		 	clrMonUI();
		 	LoadMonScope();
	 	 	LoadMonItem();
	 	 	var parentData = $(this).treegrid('getParent',row.id);
	 	 	var tmpNote = "<font color='" + parentData.color +"'>" + parentData.text +"</font>"
	 	 	setMonItem(tmpNote);
		},
		onLoadSuccess: function(row, data){
			$(this).treegrid('select', data.rows[1].id);
		},
		rowStyler: function(row){
			var color;
			if (row.color){
				color = row.color;
			}
			//else if (row._parentId){	//�����б�ɫ
			//	color = $(this).treegrid('getParent',row.id).color;
			//}
			if (color){
				return 'color:' + color; 
			}
		}
	});	
}
/// ���ز��˼໤��Χ[��׼]
function LoadPatMonScopeList(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=getPatMonScopeList',
		data: {monId:monId},
		success:function(jsonString){
			setPatMonScopeList(jsonString);      
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	});
}

/// ���˼໤��Χ[��׼]
function setPatMonScopeList(jsonString){
	 var mPatMonScopeListObj = jQuery.parseJSON(jsonString);
     for(var i=0;i<mPatMonScopeListObj.length;i++){
	     $('input[name='+mPatMonScopeListObj[i].monScopeID+']').attr("checked", true);
     }
}

/// ���ز��˼໤��Ŀ[��׼]
function LoadPatMonItemList(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=getPatMonItemList',
		data: {monId:monId},
		success:function(jsonString){
			setPatMonItemList(jsonString);      
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	});
}

/// ���˼໤��Ŀ
function setPatMonItemList(jsonString){
	var mPatMonItemListObj = jQuery.parseJSON(jsonString);
    for(var i=0;i<mPatMonItemListObj.length;i++){
	    $('input[name='+mPatMonItemListObj[i].monItemID+']').val(mPatMonItemListObj[i].monItemVal);
    }
}

/// �ύ����
function save(){

	/// �໤��Χ�б�
	var LevScopeArr=[];LevScopeList="";
	$("#m_LevScope div input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	LevScopeArr.push(this.name);
		}	
	});
	LevScopeList=LevScopeArr.join("||");
	if(LevScopeList == ""){
		$.messager.alert('��ʾ','<font style="color:red;font-weight:bold;">����д�������ָ�꣡</font>','warning');
		return;
	}

	///�໤��Ŀ�б�	
	var LevItemArr=[];LevItemList="";
	$("#m_LevItem tr input").each(function(){
		if($(this).val() != ""){
			LevItemArr.push(this.name+"^"+$(this).val());
		}
	});
	LevItemList=LevItemArr.join("||");
	if(LevItemList == ""){
		$.messager.alert('��ʾ','<font style="color:red;font-weight:bold;">����д��������������</font>','warning');
		return;
	}

	var ImpMonItems=$("#ImpMonItems").val();       ///��Ҫ������
	if((ImpMonItems=="�༭����...")||(ImpMonItems=="")){
		$.messager.alert('��ʾ','<font style="color:red;font-weight:bold;">����д������ػ�������</font>','warning');
		return;
		}
	var ImpMonContent=$("#ImpMonContent").val();   ///����ת�����
	if((ImpMonContent=="�༭����...")||(ImpMonContent=="")){
		$.messager.alert('��ʾ','<font style="color:red;font-weight:bold;">����д���˲���ת�������</font>','warning');
		return;
		}
	
	//ҩѧ�໤����Ϣ
	var monMainList="^^^^^"+ImpMonContent+"^"+ImpMonItems;
	var monMInfoList=monMainList+"!!"+LevScopeList+"!!"+LevItemList;

	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=saveMedMonInfo',//�ύ������  
		data: "monID="+monId+"&param="+monMInfoList,//�ύ�Ĳ���  
		success:function(jsonString){
			var mjsonObj = jQuery.parseJSON(jsonString);
			if(mjsonObj[0].ErrCode == 0){
				alert("����ɹ�");
			}else{           
				alert("�������,�������:"+mjsonObj[0].ErrCode);
			}       
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
}

function clrMonUI(){
	/// �໤��Χ�б�
	$("#m_LevScope").html("");
	///�໤��Ŀ�б�	
	$("#m_LevItem").html("");
	$("#ImpMonItems").val(""); ///������
	$("#ImpMonContent").val("");   ///��Ҫ������
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
function textCounterNew(){
	var maxlimit=800
	var guidecon=$("#ImpMonContent").val()
	var rem=0
	if (guidecon.length > maxlimit){  
       //���Ԫ�����ַ�����������ַ�������������ַ����ضϣ�  
   	   guidecon = guidecon.substring(0, maxlimit); 
   }else{
       //�ڼ������ı�������ʾʣ����ַ�����  
       rem = maxlimit - guidecon.length;  
   }
   $("#remLen2").val(rem)
	}