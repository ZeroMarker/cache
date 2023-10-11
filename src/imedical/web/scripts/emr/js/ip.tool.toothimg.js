$(function(){
  /* �����Լ�ȫ�ֱ������� */
  var selectToothRepresent = {};//��ǰѡ�е���λ��ʶ��
  // ��λͼƬ����
  var DTOTAL = 5,
  D_PATH="deciduous",
  PTOTAL = 8,
  P_PATH="permanent";
  var toothSurRTUPRight = "BDOMPRT"; //��������������˳��
  var toothSurRTLOWRight = "LDOMBTR"; //��������������˳��
  var toothSurRTUPLeft = "BMODPRT"; //��������������˳��
  var toothSurRTLOWLeft = "LMODBTR"; //��������������˳��
  var selectColor = "#ffb300";
  //��λ���뷽ʽ:��̨ȡֵ
  var toothIdent = {};
  //����õĹ���ֵ��ǰ�˵����ֵ
  var selectTooth = {};
  //����λͼ����ʱĬ�ϵ���������
  var lightInitFace = [];
  //���ر�־�����������Ƿ��Ѿ���ʼ��
  var PermanentFlag=0,DeciduousFlag=0;
  /* �������� */
  //��ȡ��λ��ʾ��
  function getToothRepresentation()
  {
    $.ajax({ 
      type: "POST", 
      url: "../EMRservice.Ajax.Tooth.cls", 
      data: "Action=ToothIdent", 
      error: function()
      {
        alert("��ȡ��ʼ����λ����ϵͳ��Ϣʧ��!");
      }, 
      success: function(d)
      {
        if (d == "-1")
        {
          alert("��ȡ��ʼ����λ����ϵͳ��Ϣʧ��!");
        }
        else
        {
          var strJson = JSON.parse(d);
          $("#toothMethod").combobox({
            data:strJson.ident,
            valueField:"Code",
            textField:"Desc",
            onSelect:function(record){
              setToothRepresentation(record);
            },
            onLoadSuccess:function(){
              if(parent&&parent.getSelectedToothObj){
                var selectedToothObj = parent.getSelectedToothObj();
                if(selectedToothObj!==""){
	                if(selectedToothObj.ToothCodeSystem){
                  		$("#toothMethod").combobox("select",selectedToothObj.ToothCodeSystem);
	                }else{
	                	if(parent.lastrt){
                  			$("#toothMethod").combobox("select",parent.lastrt);
	                	}else{
		            		//����Ĭ�� 
		            		$("#toothMethod").combobox("select",strJson.select);   
		            	}		                
		            }
                }else{
	                if(parent.lastrt){
                  		$("#toothMethod").combobox("select",parent.lastrt);
	                }else{
		            	//����Ĭ�� 
		            	$("#toothMethod").combobox("select",strJson.select);   
		            }
                }
              }else{
                $("#toothMethod").combobox("select",strJson.select);
              }
            }
          });
        }
      }
    });
  }
  function setToothRepresentation(record)
  {
    selectToothRepresent = record;
    //���ý�����ʾ��ţ����½���
    updateToothPage();
  }
  //���ݱ�ʶ����ʾ��Ӧ����λ���
  function updateToothPage(){
    $(".box").each(function(){
      var id = $(this).prop("id");
      var num =selectToothRepresent.ToothIdent[id].ToothPDes;
      $(this).find(".box-num-label span.toothImg").text(num);
    });
  }
  //��ȡ��λ��Ӧ�ı�����Ϣ
  function initIdentData(){
    $.ajax({
      type:"POST",
      async:false,
      url:"../EMRservice.Ajax.Tooth.cls",
      data: "Action=ToothNumAndSur", 
      error: function()
      {
        alert("��ȡ��������ʧ��!");
      }, 
      success: function(d)
      {
        toothIdent = eval("("+d+")");
      }
    });
  }
  // ����ͼƬ��Ϣ
  function initToothImg(ShowModeCode){
	//��ȡ��ǰѡ�е�radioֵ
	if(ShowModeCode==="ToothDeciduous"){
	    //��������
	    if(DeciduousFlag===0){
    		DeciduousFlag=1;
    		addTypeTooth("deciduous",DTOTAL,D_PATH);
	    }	
	}else if(ShowModeCode==="ToothPermanent"){
    	//���ɺ���
    	if(PermanentFlag===0){
	    	PermanentFlag=1;
	    	addTypeTooth("permanent",PTOTAL,P_PATH);
	    	}		
	}else if(ShowModeCode==="ToothAll"){
	    if(DeciduousFlag===0){
    		DeciduousFlag=1;
    		addTypeTooth("deciduous",DTOTAL,D_PATH);
	    }
    	if(PermanentFlag===0){
	    	PermanentFlag=1;
	    	addTypeTooth("permanent",PTOTAL,P_PATH);
	    	}
	}
  }
  //�����������������λ
  function addTypeTooth(selector,total,path){
    var divUpL_TR = document.createElement("div");
    $(divUpL_TR).prop("class","divLeft-tr");
    var divUpR_TL = document.createElement("div");
    $(divUpR_TL).prop("class","divRight-tl");
    var divLowL_TR = document.createElement("div");
    $(divLowL_TR).prop("class","divLeft-tr");
    var divLowR_TL = document.createElement("div");
    $(divLowR_TL).prop("class","divRight-tl");
    //����4�����޵�ǰ׺������ALL ALR AUL AUR/����CUL CUR CLL CLR 
    var prefix = "";
    if(selector==="deciduous"){
      //����
      prefix="C";
    }else{
      prefix="A";
    }
    for(var i=1;i<=total;i++){
      $(divUpL_TR).append(addTooth({direction:"Up",quadrant:prefix+"UR",codeI:i,path:path}));
      $(divUpR_TL).append(addTooth({direction:"Up",quadrant:prefix+"UL",codeI:i,path:path}));
      $(divLowR_TL).append(addTooth({direction:"Low",quadrant:prefix+"LL",codeI:i,path:path}));
      $(divLowL_TR).append(addTooth({direction:"Low",quadrant:prefix+"LR",codeI:i,path:path}));
    }
    $("."+selector+".top").append(divUpL_TR,divUpR_TL);
    $("."+selector+".bottom").append(divLowL_TR,divLowR_TL);
  }
  //���һ��box����Ϊһ����λ������ţ��������ڣ�����
  function addTooth(paramObj){
	var direction = paramObj.direction;
	var quadrant = paramObj.quadrant;
	var codeI = paramObj.codeI;
	var path = paramObj.path;
	/*--��ȡ��������--*/
    var defaultColor = "";
    var toothPosition = quadrant+"."+codeI;
    selectTooth[toothPosition]!==undefined?defaultColor=selectColor:defaultColor="";
    var numDiv = "<div class=\"box-num-label\">\<span class=\"toothImg\" style=\"background-color:"+defaultColor+";\">"+toothIdent[toothPosition].Desc+"</span></div>"
    var box = document.createElement("div");
    $(box).prop("class","box");
    $(box).prop("id",toothPosition);
    //�����������
    var box_surface_main = document.createElement("div");
    $(box_surface_main).prop("class","box-surface");
    var box_surfaceContent = box_surface_main;
    //�������ڵ�������
    var box_rt_main = document.createElement("div");
    $(box_rt_main).prop("class","box-rt");
    var box_rtContent = box_rt_main;
    // �������box-surface����������
    var sort = "";
    if(direction==="Up"){
      sort = quadrant.indexOf("UL")!==-1?toothSurRTUPLeft:toothSurRTUPRight;
       //����
      $(box_rt_main).css("position","relative");
      $(box_rt_main).append("<div class='upRTOuter'></div>");
      box_rtContent = $(box_rt_main).children("div.upRTOuter");
      //����
      $(box_surface_main).css("position","relative");
      $(box_surface_main).append("<div class='upSurOuter'></div>");
      box_surfaceContent = $(box_surface_main).children("div.upSurOuter");
    }else if(direction==="Low"){
      sort = quadrant.indexOf("LL")!==-1?toothSurRTLOWLeft:toothSurRTLOWRight;
    }
    
    var surLen = sort.length;
    var boxDom = "";
    for(var j=0;j<surLen;j++){
      if(sort[j]==="R"||sort[j]==="T"){
        boxDom = box_rtContent;
      }else{
        boxDom = box_surfaceContent;
      }
      var surfaceItemObj=toothIdent[toothPosition].SurfaceObj[sort[j]];
      if(surfaceItemObj){
        createImgDom(boxDom,surfaceItemObj,path,direction);
      } 
    }
    if(direction==="Up"){
      $(box).append(box_surface_main,box_rt_main,numDiv);
    }else{
      $(box).append(numDiv,box_rt_main,box_surface_main);
    }
    return box;
  }
  //���ͼƬ����Ӧ�ĺ�����
  function createImgDom(dom,surfaceItemObj,path){
    var ToothSICode = surfaceItemObj.ToothSICode;
    var defaultColor = "",letter = surfaceItemObj.ToothSIDes;
    if($.inArray(ToothSICode,lightInitFace)!==-1){
      defaultColor = selectColor;
    }
    var imgName = ToothSICode+".png";
    var srcStr = "../scripts/emr/image/tool/tooth-1-0.6/"+path+"/"+imgName;
    //����Image����
    var toothNum = imgName.split(".")[1];
    var imgclass =  "toothImg rts_"+letter;
    if(toothNum<=3){
	    //����ǰ����ͼƬ�Ĵ�С
	    imgclass = imgclass+" Resize_"+letter;
	    }
	if((letter==="R"||letter==="T")&&isClickRT===false){
	    //���ò�����������ɫ
	    imgclass = imgclass+" RTImgDisable";
	    }
    var ImgObj = new Image();
    ImgObj.src = srcStr;
    ImgObj.className = imgclass;
    ImgObj.style["background-color"] = defaultColor;
    ImgObj.alt = letter;
    ImgObj.setAttribute("loading","lazy");
    
    //var imgStr= '<img class="toothImg rts_'+letter+'" src='+srcStr+'  style="background-color:'+defaultColor+';" alt="'+letter+'"></img>';

    $(dom).append(ImgObj);
	    
  }
  /* ��ӵ���¼� ��ѡ��ť�ĵ��*/
  //��������¼�
  $("#addToRecord").click(function(){
    returnValue = getToothData();
    closeWindow();
  });
  $("#resetTooth").click(function(){
	  $.messager.confirm("��ʾ","�Ƿ���յ�ǰѡ���ȫ����λ��Ϣ��",function(r){
		  if(r){
				$.each(selectTooth,function(key,value){
					var selector = key.replace(".","\\.");
					unCheckBox($("#"+selector))
					//��յ�ǰѡ���������λ
				});
				selectTooth = {};
			  }
		  });
	  });
  function getToothData(){
    var obj = {},ShowMode="",prefix="";
    //��ѡ�����λ���б���
    var ShowModeCode = $('input:radio[name="toothRadio"]:checked').val();
    if(ShowModeCode==="ToothAll"){
      ShowMode = "�����";
	  prefix = "All";
    }else if(ShowModeCode==="ToothDeciduous"){
      ShowMode = "����";
      prefix = "C";
    }else{
      ShowMode = "����";
      prefix = "A";
    }
    var areaTeeth = {
      upLeft :[],
      upRight:[],
      downLeft:[],
      downRight:[]
    };
    var boxObj;
    $.each(selectTooth,function(key,value){
      if((prefix==="All"||key.charAt(0)===prefix)&&value!==undefined){
        // toothNum++;
        boxObj = {
          ToothInCode : key,
          AreaType : selectToothRepresent.ToothIdent[key].ToothPQuadrant,
          ToothCode : toothIdent[key].Desc,
          ToothDisplayName : toothIdent[key].Define,
          ToothValue : selectToothRepresent.ToothIdent[key].ToothPDes,
          ToothSurfaceValue : value,
          ToothSurfaceItems : getToothSurface(key,value)
        }
        var type = key.split(".")[0].slice(1);
        getQuadrant(type,boxObj,areaTeeth);
      }
    });
    obj.InstanceID = "";
    obj.ShowMode = ShowMode;
    obj.ToothCodeSystem = selectToothRepresent.Code;
    obj.ToothCodeSystemName = selectToothRepresent.Desc;
    obj.ToothSurfaceCodeSystem = selectToothRepresent.Code;
    obj.ToothSurfaceCodeSystemName = selectToothRepresent.Desc;
    obj.UpLeftAreaTeeth = areaTeeth.upRight;
    obj.UpRightAreaTeeth = areaTeeth.upLeft;
    obj.DownLeftAreaTeeth = areaTeeth.downRight;
    obj.DownRightAreaTeeth = areaTeeth.downLeft;
    // obj.toothNum = toothNum;
    return obj;
  }
  function getToothSurface(key,surValue){
    var res=[],surCode="";
    var len = surValue.length;
    for(var i=0;i<len;i++){
      surCode = surValue[i];
      if(isClickRT===false&&(surCode==="R"||surCode==="T")){
	      continue
	  }
      res.push({
        InCode:key+"."+surCode,
        Code: surCode,
        Value: surCode,
        ToothSurfaceDisplayName: toothIdent[key].SurfaceObj[surCode].ToothSIDes,
        ScriptMode: "SuperScript"    
      });
    }
    return res;
  }
  function getQuadrant(type,boxObj,areaTeeth){
    // var toothObj = JSON.parse(JSON.stringify(boxObj));
    switch(type){
      case 'UL':{
        areaTeeth.upLeft.push(JSON.parse(JSON.stringify(boxObj)));
        break;
      }
      case 'UR':{
        areaTeeth.upRight.push(JSON.parse(JSON.stringify(boxObj)));
        break;
      }
      case 'LL':{
        areaTeeth.downLeft.push(JSON.parse(JSON.stringify(boxObj)));
        break;
      }
      case 'LR':{
        areaTeeth.downRight.push(JSON.parse(JSON.stringify(boxObj)));
        break;
      }
      default:{
        break;
      }
    }
  }
  //�رմ���
  function closeWindow() {
    if((parent)&&(parent.closeDialog)){
      parent.setLastRepresentation(selectToothRepresent.Code);
      parent.closeDialog("toothDialog");
    }
  }
  $HUI.radio("[name='toothRadio']",{
    onChecked:function(e,value){
      var value = $(e.target).attr("value");
      if (value === "ToothDeciduous"){
        $(".deciduous").css("display","");
        $(".permanent").css("display","none");
        $(".flagPermanent").css("display","none");
        $("#line").attr("class","cross-line-deciduous");
        $("#FlagRight").css("left","170px");
        $("#FlagLeft").css("right","170px");
        //����
        $(".flag-rl-middle").css("padding-top","40px");
        //����
        $(".tooth-main").css("height","260px");
        $(".flag-rl-middle").css("margin","auto");
        $("#righttext").css("margin","0");
        $("#lefttext").css("margin","0");
        initToothImg(value);
      }else if (value === "ToothAll"){     
        $(".deciduous").css("display","");
        $(".permanent").css("display","");
        $(".flagPermanent").css("display","none");
        $("#line").attr("class","cross-line");
        $("#FlagRight").css("left","0px");
        $("#FlagLeft").css("right","0px");
        $(".flag-rl-middle").css("padding-top","40px");
        //����
        $(".tooth-main").css("height","580px");
        $(".flag-rl-middle").css("margin","auto");
        $("#righttext").css("margin","0");
        $("#lefttext").css("margin","0");
        initToothImg(value);    
      }else{
        $(".deciduous").css("display","none");
        $(".permanent").css("display","");
        $(".flagPermanent").css("display","");
        $("#line").attr("class","cross-line");
        $("#FlagRight").css("left","0px");
        $("#FlagLeft").css("right","0px");
        $(".flag-rl-middle").css("padding-top","0px");
        //����
        $(".tooth-main").css("height","338px");
        //����������ʽ
        $(".flag-rl-middle").css("margin","0");
        $("#righttext").css("margin","127px 0px 109px 0px");
        $("#lefttext").css("margin","127px 0px 109px 0px");
        initToothImg(value);
      }
    }
  });
  //�����λ background-color:#ffb300
  $(".tooth-layout").on("click",".toothImg",function(){ 
    var clickType = $(this).prop("tagName").toUpperCase();
    //��ǰ�������ͼƬ
    if(clickType==="IMG"){
      clickImg(this);
    }else{
      clickNumber(this);
    }  
  });
  function clickImg(_this){
	if(isClickRT===false){
		if(/rts_(R|T)/.test($(_this).attr("class"))){
			return;
			}
	}
    var $box = $(_this).parents("div.box");
    var $numSpan = $box.children("div.box-num-label").children("span");
    var boxID = $box.prop("id");
    var surCode = $(_this).prop("class").split(" ")[1].split("_")[1];
    if(!selectTooth[boxID]||selectTooth[boxID].indexOf(surCode)===-1){
      $(_this).css("background-color",selectColor);
      //�������
      $numSpan.css("background-color",selectColor);
      selectTooth[boxID]?selectTooth[boxID] += surCode:selectTooth[boxID]=surCode;
	  offReverseTooth(boxID);
    }else{
      var reg = new RegExp(surCode,"g");
      selectTooth[boxID] = selectTooth[boxID].replace(reg,"");
      $(_this).css("background-color","");
      // if(selectTooth[boxID]===""){
      //   $numSpan.css("background-color","");
      //   selectTooth[boxID] = undefined;
      // }
    } 
    // resetCheckBox($box);
  }
  function clickNumber(_this){
    var $box = $(_this).parents("div.box");
    var boxID = $box.prop("id");
    if(selectTooth[boxID]===undefined){
      $(_this).css("background-color",selectColor);
      selectTooth[boxID] = "";
	  offReverseTooth(boxID);
    }else{
	  unCheckBox($box);
    }
    // resetCheckBox($box);	
  }
    //ȡ������������Ӧ���ݵ�ѡ��
  function offReverseTooth(boxID){
  	if(boxID.indexOf("8")===-1){
      //ȡ����Ӧλ�õĵ���
      if(boxID.charAt(0)==="A"){
	      ReverseBoxID = "C"+boxID.slice(1);
	      }else{
		  ReverseBoxID = "A"+boxID.slice(1);   
		  }
	  var $reverseBox=$(document.getElementById(ReverseBoxID));
	  unCheckBox($reverseBox);
      }	  
  }
    //���޵��ȫѡ
  function quadrantTooth(areaClass,id){
    var toothClass = "permanent",divClass="";
    switch(areaClass){
      case 'check-left-top':
      case 'check-left-bottom':{
        divClass = "divRight-tl";
        break;
      }
      case 'check-right-top':
      case 'check-right-bottom':{
        divClass = "divLeft-tr";
        break;
      }
    }
    if(toothClass!==""){
      $("."+toothClass+"."+areaClass.split("-")[2]+" ."+divClass).children("div.box").each(function(){
        //��ѡ��8���ǳ�
        var boxID = this.id;
        if(boxID&&boxID.indexOf("8")===-1){
          var checkFlag = $(id).attr("class");
          if(checkFlag.indexOf("selectFlag")!==-1)
          {
            checkBox($(this));
          }else{
            unCheckBox($(this));
          }			
        }
      });
    }
  }
  function checkBox($box){
    var boxID = $box.prop("id");
    $box.prop("name","checked");
    $box.find(".box-num-label .toothImg").css("background-color",selectColor);
    selectTooth[boxID] = "";
  }
  function unCheckBox($box){
    var boxID = $box.prop("id");
    $box.prop("name","unchecked");
    $box.find(".toothImg").css("background-color","");
    selectTooth[boxID] = undefined;   
  }
  //���ø�ѡ��
  function resetCheckBox($box){
    var checkflag = false,unCheckflag=false;
    $box.parent().find("div.box").each(function(){
      var name = $(this).prop("name");
      var id = $(this).prop("id");
      if(id.indexOf("8")===-1){
        if(name==="checked"){
          checkflag = true;
          }
        if(name==="unchecked"||name===undefined){
          unCheckflag = true;
          }
      }   
    });
    var checkboxStatus = "";
    if(!(checkflag&&unCheckflag)){
      if(checkflag){
        checkboxStatus = true;
        }
      if(unCheckflag){
        checkboxStatus = false;
        }
      var parDiv = $box.parents("div.permanent");
      var areaClass =parDiv.prop("class")+$box.parent().prop("class");
      if(areaClass.indexOf("top")!==-1){
        if(areaClass.indexOf("divLeft-tr")!==-1){
          $("#flagRightTop").checkbox("setValue",checkboxStatus);
        }else if(areaClass.indexOf("divRight-tl")!==-1){
          $("#flagLeftTop").checkbox("setValue",checkboxStatus);
        }
      }
      else if(areaClass.indexOf("bottom")!==-1){
        if(areaClass.indexOf("divLeft-tr")!==-1){
          $("#flagRightBottom").checkbox("setValue",checkboxStatus);
        }else if(areaClass.indexOf("divRight-tl")!==-1){
          $("#flagLeftBottom").checkbox("setValue",checkboxStatus);
        }
      }	
    }	
  }
  function initToothData(){
    if ((parent)&&(parent.getSelectedToothObj)){
      var selectedToothObj = parent.getSelectedToothObj();
      if (selectedToothObj!=="")
      {
	    InitOperedTooth();
        if(selectedToothObj.ShowMode==="����"){
          $HUI.radio("#ToothDeciduous").setValue(true);       
        }else if(selectedToothObj.ShowMode==="����"){
          $HUI.radio("#ToothPermanent").setValue(true);   
        }else if(selectedToothObj.ShowMode==="�����"){
          $HUI.radio("#ToothAll").setValue(true);
        }else{
	    	  //��������Ĭ�Ϲ�ѡ�������������
  			  setDefaultRadio();    
	    }
      }else{
	      setDefaultRadio(); 
	      }
    }else{
	    //��������Ĭ�Ϲ�ѡ�������������
  		setDefaultRadio();
	    }
    function InitOperedTooth(){
      selectedToothObj.UpLeftAreaTeeth?areaSingleTooth(selectedToothObj.UpLeftAreaTeeth):1==1;
      selectedToothObj.UpRightAreaTeeth?areaSingleTooth(selectedToothObj.UpRightAreaTeeth):1==1;
      selectedToothObj.DownLeftAreaTeeth?areaSingleTooth(selectedToothObj.DownLeftAreaTeeth):1==1;
      selectedToothObj.DownRightAreaTeeth?areaSingleTooth(selectedToothObj.DownRightAreaTeeth):1==1;      
    } 
    function areaSingleTooth(Arry){
      var leng = Arry.length;
      for(var i=0;i<leng;i++){
        var boxID = Arry[i].ToothInCode;
        selectTooth[boxID] = "";
        var surfaceArry =  Arry[i].ToothSurfaceItems;
        var str = "";
        for(var j=0;j<surfaceArry.length;j++){
          str += surfaceArry[j].Code;
          lightInitFace.push(boxID+"."+surfaceArry[j].Code);
        }
        selectTooth[boxID] = str;
      }
    }
  }

  /* ���������Լ�����Ĭ��ֵ */
  window.quadrantTooth = quadrantTooth;
  //�¼���
  function clickBtn(id){
		var flag = $(id).prop("class");
		if(flag.indexOf("selectFlag")!==-1){
			 $(id).removeClass( "selectFlag" );
			}else{
				$(id).addClass( "selectFlag" );
			}		
		}
	$("#flagLeftTop").click(function(){
		clickBtn("#flagLeftTop");
		quadrantTooth('check-left-top',"#flagLeftTop");
		});
	$("#flagRightTop").click(function(){
		clickBtn("#flagRightTop");
		quadrantTooth('check-right-top',"#flagRightTop");
	});
	$("#flagLeftBottom").click(function(){
		clickBtn("#flagLeftBottom");
		quadrantTooth('check-left-bottom',"#flagLeftBottom");
	});
	$("#flagRightBottom").click(function(){
		clickBtn("#flagRightBottom");
		quadrantTooth('check-right-bottom',"#flagRightBottom");
	});
	 //���ݿ�������ѡ�ж�Ӧ��radio
	function setDefaultRadio(){ 
		try{
			var defaultRadioObj = JSON.parse(defaultRadio);
			var allStr = defaultRadioObj.ToothAll;
			var PStr = defaultRadioObj.ToothP;
			var DStr = defaultRadioObj.ToothD;
			var reg = new RegExp("\\b"+userLocID+"\\b","g");
			if(PStr&&PStr.search(reg)!==-1){
				//ѡ�к���
				$HUI.radio("#ToothPermanent").setValue(true);
			}else if(DStr&&DStr.toString().search(reg)!==-1){
				//ѡ������
				$HUI.radio("#ToothDeciduous").setValue(true);			
			}else if(allStr&&allStr.toString().search(reg)!==-1){
				//ѡ�л����
				$HUI.radio("#ToothAll").setValue(true);				
			}else{
				//ѡ�к���
				$HUI.radio("#ToothPermanent").setValue(true);			
			}
			
		}catch(e){
				//ѡ�к���
				$HUI.radio("#ToothPermanent").setValue(true);			
		}	
	}
  //��ʼ��ident����
  initIdentData();
  //��ʼ��ѡ�е���λ
  initToothData();
  getToothRepresentation();
})
