 
 /// ҩѧ�໤�༭
 var url="dhcpha.clinical.action.csp";
 var monLevId=""; //�໤����ID
 var monLevelDesc=""  //�໤��������
 var monLocID=""; //���˿���ID
 var monAdmID=""; //����ID
 var monSubClassId=""; //ѧ�Ʒ���ID
 var monWardID="";
 var monID="";

 $(function(){
	 
	 monLevId=getParam("monLevId");  /*csp����*/
	 monLevelDesc=getParam("monLevelDesc");
	 monLevelDesc=unescape(monLevelDesc)
	 if(monLevelDesc.indexOf("@")){
		monLevelDesc = "<font color="+ monLevelDesc.split("@")[1] +">"+monLevelDesc.split("@")[0]+"</font>"; 
	 }
	 monLocID=getParam("monLocID");
	 monAdmID=getParam("monAdmID");
	 monWardID=getParam("monWardID");
	 monSubClassId=getParam("monSubCId");
	 setMonItem();
 	 InitUI();
 	 LoadMonScope();  /// ��ʼ���໤��׼�б�
 	 LoadMonItem();   /// ��ʼ���໤��Ŀ�б�
 	 $("#btnAddEmp").bind("click",save);  //�ύ
 	 SpecControlInputShow(); ///�������
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
 function setMonItem(){
	 var notes = "";	 
	 /* if(monLevId == "1"){
	 	notes="[����һ�Ϊһ���໤]";
	 }else if(monLevId == "2"){
	 	notes="[����һ�Ϊ�����໤]";
	 }else{
	 	notes="[����һ�Ϊ�����໤]";
	 } */
	  notes="[����һ�Ϊ"+monLevelDesc+"�໤]";
	 $('span.ui-font12:contains("����")').html(notes);
 }
 
 /// ���ؼ໤��Χ
 function LoadMonScope(){
	 $.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=getMonScopeList',//�ύ������ �����ķ���  
		data: {monSubClassId:monSubClassId, monLevId:monLevId}, //�ύ�Ĳ���  
		success:function(jsonString){			
			createLevScope(jsonString);  
			pageBasicControll();    
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	}); 
 }
 
 /// ���ؼ໤��Ŀ
 function LoadMonItem(){
	createLevClass(monSubClassId);  	//  ��д���ؼ໤��Ŀ quniapeng 2018/3/17
	checkLevelControl();
	/* $.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=getMonItemList',
		data: {monSubClassId:monSubClassId, monLevId:monLevId},
		success:function(jsonString){ 
			//createLevItm(jsonString); 
			createLevClass(monSubClassId);
			//pageBasicControll();      
			checkLevelControl();
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	}); */
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
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	});
 }
 
 //����name��¼CheckBoxMain��ѡ�����ѡ�ѡ��			qunianpeng  2016-09-18
 function pageBasicControll()
 {
 	$("input").bind('click',function(){
		$("input[name='CheckBoxMain']").each(function(){
			if($(this).attr("checked")){
				var CheckAllId=$(this).attr('id');
				$('.'+CheckAllId).css("display","block")
			}else{
				var CheckAllId=$(this).attr('id');
				$('.'+CheckAllId).css('display','none')
			}
		}) 
	})
 }
 
  //���Ƽ໤��Ŀ��ѡ�����ѡ�ѡ��			qunianpeng  2018-03-17
 function checkLevelControl()
 {
 	$(".cblevel").bind('click',function(){
	 	$(".cblevel").each(function(){
			if($(this).attr("checked")){
				$(this).next().css("display","block");
			}else{
				$(this).next().css('display','none')
			}
		});		
	});
 }
  
 ///  ��̬���ؼ໤��Χ�����б�     qunianpeng  2016-09-18
 function createLevScope(jsonString){
	 var mLevScopeListObj = jQuery.parseJSON(jsonString);
     var htmlls = '';
     for(var i=0;i<mLevScopeListObj.length;i++){
			htmlls = ' <tr> '			//����ѧ�Ʒ���
			htmlls = htmlls +'<td> <input id="'+mLevScopeListObj[i].PHMSCRowID+'" class="cb" type="checkbox" name="CheckBoxMain" />'+mLevScopeListObj[i].PHMSCDesc+' </td> '     	
			htmlls =htmlls+' </tr>' 
			var temp = $('#'+mLevScopeListObj[i].PHMSCRowID);			
			if ((temp.length <= 0)) {	  //���ظ�������ͬ��ѧ�Ʒ���	
					$('#m_LevScope').append(htmlls);	
			}
				
			htmlls = ' <tr style="display:none" class="'+mLevScopeListObj[i].PHMSCRowID+'"> '				//���������׼
			htmlls =htmlls +'<td> <input type="checkbox" class="cb" style="margin-left:40px" value="'+mLevScopeListObj[i].monScopeID+'" />'+mLevScopeListObj[i].monScopeDesc+' </td> '     	
			htmlls =htmlls+' </tr>'				
			$('#m_LevScope').append(htmlls);  
		     								 
	 }

     $("div[id='mainpanel']").css('overflow','auto');  //��������������Զ���������
     ///LoadPatMonScopeList();
     ///LoadPatMonItemList();
     ///LoadMonImpLabsAndGuidCon();
 }


 /// ��̬�����໤��Ŀ  qunianepng 2018/3/16
 function createLevClass(monSubClassId){
	 runClassMethod("web.DHCSTPHCMPHARCAREMAIN","GetScopeDescList",{"classId":monSubClassId},function(jsonString){	
	 	if (jsonString != ""){		
			$.each(jsonString,function(index,obj){
				var htmls = "";
				 htmls = htmls + '<div> <input id="'+obj.classDesc+'" class="cblevel" type="checkbox" name="CheckBoxClass" />'+obj.classDesc+' ';  
				 runClassMethod("web.DHCSTPHCMPHARCAREMAIN","getMonItemListNew",{"classId":obj.classId,"monLevelId":monLevId},function(jsonObj){			
					if (jsonObj != ""){
						htmls = htmls + '<table style="margin-left:20px; display:none; ">';
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
					else{
						alert("��ȡ����ʧ��!");
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
 
 ///��̬���ؼ໤��Ŀ�����б�    qunianepng 2016-09-19
 function createLevItm(jsonString){
	 
	 var mLevItmListObj = jQuery.parseJSON(jsonString);
     var htmlls = '';
     var subhtmls = '';
     var $td = 'width:30%;';
	 var spanleft  = 'margin-left:10px; margin-right:5px;';
	 var spanright = 'margin-left:5px;  margin-right:100px;';
     for(var i=0;i<mLevItmListObj.length;i++){
			htmlls = ' <div><tr> '			//����ѧ�Ʒ���
			htmlls = htmlls +'<td> <input id="'+mLevItmListObj[i].PHMSCDesc+'" class="cb" type="checkbox" name="CheckBoxMain" />'+mLevItmListObj[i].PHMSCDesc+' </td> '     	
			htmlls = htmlls+' </tr></div>' 
			var temp = $('#'+mLevItmListObj[i].PHMSCDesc);	
			if ((temp.length <= 0)) {	  //���ظ�������ͬ��ѧ�Ʒ���	
					$('#m_LevItem').append(htmlls);	
			}		
			
			htmlls = '<tr  style="display:none;margin-left:40px;width:100%"  class="'+mLevItmListObj[i].PHMSCDesc+'"> '				//���������׼
			htmlls =htmlls +'<td style="width:35%;align:right">'+mLevItmListObj[i].monItemDesc+'</td> ' 
			htmlls = htmlls +'<td style="width:50%">'+'<input  type="text" name="'+mLevItmListObj[i].monItemID+'" /> ' + '</td>'	
			htmlls =htmlls+' </tr>'			
			
			$('#m_LevItem').append(htmlls); 
	 }	 
	
     $("div[id='mainpanel']").css('overflow','auto');  //��������������Զ���������
}

/// ���ز��˼໤�б�
function LoadPatMonList(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=getPatMonList',
		data: {monLevId:monLevId,AdmDr:AdmDr},
		success:function(jsonString){
			createPatMonList(jsonString);      
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	});
}

function createPatMonList(jsonString){
	 var mPatMonListObj = jQuery.parseJSON(jsonString);
     var htmlls1 = '';htmlls2 = '';htmlls3 = "";
     for(var i=0;i<mPatMonListObj.length;i++){
	     if(mPatMonListObj[i].monLeID=="1"){
     	 	htmlls1 = htmlls1 + '	   <li><a href="#">'+mPatMonListObj[i].monDate+" "+mPatMonListObj[i].monUser+'</a></li>';
	     }
	     if(mPatMonListObj[i].monLeID=="2"){
     	 	htmlls2 = htmlls2 + '	   <li><a href="#">'+mPatMonListObj[i].monDate+" "+mPatMonListObj[i].monUser+'</a></li>';
	     }
	     if(mPatMonListObj[i].monLeID=="3"){
     	 	htmlls3 = htmlls3 + '	   <li><a href="#">'+mPatMonListObj[i].monDate+" "+mPatMonListObj[i].monUser+'</a></li>';
	     }
     }
     $('#m_PatMonList1').append(htmlls1);
     $('#m_PatMonList2').append(htmlls2);
     $('#m_PatMonList3').append(htmlls3);
     $("div.list").css('overflow','auto');  //��������������Զ���������
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
	var LevScopeArr=[];
	$("#m_LevScope input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
			if(this.value!="on"){
          		LevScopeArr.push(this.value);
			}
		}	
	}); 
	LevScopeList=LevScopeArr.join("||");
	if(LevScopeList == ""){
		$.messager.alert('��ʾ','<font style="color:red;font-weight:bold;">����д�������ָ�꣡</font>','warning');
		return;
	}

	///�໤��Ŀ�б�	
	var LevItemArr=[];
	$("#m_LevItem input").each(function(){
		if(($(this).val() != "")&&(this.name!="CheckBoxClass")){
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
	var monMainList=monLevId+"^"+monAdmID+"^"+monWardID+"^"+monLocID+"^"+LgUserID+"^"+ImpMonContent+"^"+ImpMonItems;
	var monMInfoList=monMainList+"!!"+LevScopeList+"!!"+LevItemList+"!!"+"";

	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=saveMedMonInfo',//�ύ������  
		data: "monID="+monID+"&param="+monMInfoList,//�ύ�Ĳ���  
		success:function(jsonString){
			var mjsonObj = jQuery.parseJSON(jsonString);
			if(mjsonObj[0].ErrCode == 0){
				alert("����ɹ�");
			}else{           
				alert("�������,�������:"+mjsonObj[0].ErrCode);
			} 
			window.parent.loadParWin();  //���ø���ܵķ���������ˢ��      
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
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
/// �������
function SpecControlInputShow(){
	if((monLevId == "1")&(monSubClassId == "8")){
		$('#ImpMonContent').val("Ӫ����������Һ����ml����������kcal��NPC��kcal ����͸ѹ��mOsm/L�������ǣ�g��֬����g�������᣺g���Ȼ��أ�g���Ȼ��ƣ�g��PN;��(PICC�����ܾ�����CVC ����Һ��)��");
	}
	if((monLevId == "2")&(monSubClassId == "8")){
		$('#ImpMonContent').val("Ӫ����������Һ����ml����������kcal�������ǣ� g��֬���� g�������᣺g��EN;��(���ڡ���θ�ܡ��ǿճ��ܡ�PEG/PEJ):��ÿ������:ml/�ա�(����:kcal/��)���ٶ�:ml/Сʱ����ע��ʽ(�������롢������ע������): ");
	}
}