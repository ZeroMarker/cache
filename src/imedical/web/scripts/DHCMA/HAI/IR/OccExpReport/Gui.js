//ְҵ��¶����[GUI]
var obj = new Object();
obj.BTSCheck=1;      //cjb20230220��ѡ�ı������Ż�
function InitReportWin() {
    //��ʼ�������˵�1->[�Ա�]
    //�����Է���ȡ��Ů
	obj.SexNLng = $m({          //��ǰҳ(Ĭ�����һҳ)
        ClassName: "DHCHAI.Abstract",
        MethodName: "HAIGetTranByDesc",
        aProp: "CTSEXDesc"
        ,aDesc:"��"
        ,aClassName:"User.CTSex"
    }, false);
    obj.SexVLng = $m({          //��ǰҳ(Ĭ�����һҳ)
        ClassName: "DHCHAI.Abstract",
        MethodName: "HAIGetTranByDesc",
        aProp: "CTSEXDesc"
        ,aDesc:"Ů"
        ,aClassName:"User.CTSex"
    }, false);
    obj.cboSex = $HUI.combobox("#cboSex", {
		editable: true,
		allowNull: true, 
		valueField: 'value',
		textField: 'text',
		data: [
			{ value: 'M', text: obj.SexNLng },
			{ value: 'F', text: obj.SexVLng }
        ]
	});
    //��ʼ�������˵�2->[���ڿ���]
    var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	var HospIDs=HospList.rows[0].ID;	//ȡȫ��Ժ��
	var LocType=$m({ 
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "ExpStaffLocType"
	}, false);
	if (LocType=="E"){
    	obj.cboExpLoc=Common_ComboToLoc("cboExpLoc", HospIDs, "", "", "OELocType","1");
	}
    else{
    	obj.cboExpLoc=Common_ComboToLoc("cboExpLoc", HospIDs, "", "", "OWLocType","1");
    }
    //��������(Ĭ��2~10)
    obj.SumID=2;
    obj.Sum = new Array();
	obj.Sum[2]="��",obj.Sum[3]="��",obj.Sum[4]="��",obj.Sum[5]="��",obj.Sum[6]="��";
	obj.Sum[7]="��",obj.Sum[8]="��",obj.Sum[9]="��",obj.Sum[10]="ʮ",obj.Sum[11]="ʮһ"; 	
	
    //����ҳǩ1:�ǼǱ���
    var ExtTypeIDs_1= $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryExpRegType",
        aRegTypeID: RegTypeID,
        aExtTypeID:1,
        rows:999
    }, false);
		//��ȡ������ʽ 0Ϊ���� 1Ϊcsp
	obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
	},false);
	var width="1283px"
	if(obj.flg=="0"){
	 width="auto"
	}
	//��ȡ��¶��Ϣ
	obj._RegTypeData = $cm({				
		ClassName: "DHCHAI.IRS.OccExpTypeSrv",
		QueryName: "QryOccExpType",
		aActive:"1",
		aRegTypeID: RegTypeID
	}, false);
	obj.RegTypeDesc=obj._RegTypeData.rows[0].BTDesc;
    var html_1=""
    for (var ind = 0; ind < ExtTypeIDs_1.total; ind++) {
        var ExtTypeData = ExtTypeIDs_1.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var TypeCode = ExtTypeData.TypeCode;
        var TypeDesc = ExtTypeData.TypeDesc;
        //DIV(����ΪDIV-1)
        html_1 = html_1	+"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"��"+TypeDesc + "(��עΪ*����ĿΪ������)',headerCls:'panel-header-gray'\" style='width:"+width+";padding:5px'>"
                      	+"	<div id='DIV" + TypeID + "' style='margin:0px 10px 0px 10px;'></div>"
	                  	+"</div>";
	    obj.SumID++;
    }
    $('#OccInfo_1').html(html_1);
    $.parser.parse('#OccInfo_1'); 		// ����ҳǩ1
    //����ҳǩ2:��˹۲�
    var ExtTypeIDs_2= $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryExpRegType",
        aRegTypeID: RegTypeID,
        aExtTypeID:2,
        rows:999
    }, false);
    var html_2=""
    for (var ind = 0; ind < ExtTypeIDs_2.total; ind++) {
        var ExtTypeData = ExtTypeIDs_2.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var TypeCode = ExtTypeData.TypeCode;
        var TypeDesc = ExtTypeData.TypeDesc;
        if(ind==ExtTypeIDs_2.total-1){
	    	html_2 = html_2 +"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"��׷�ټ��" + "(��עΪ*����ĿΪ������)',headerCls:'panel-header-gray'\" style='width:1280px;padding:0px 5px 5px 5px;'>"
                      	+"		<div id='LabDIV' style='margin:0px 10px 0px 10px;'>123456</div>"
        				+"</div>"
        				+"<div style='padding-bottom:10px;'></div>";
      	obj.SumID++;
	    }
        //DIV(����ΪDIV-1)
        html_2 = html_2 +"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"��" + TypeDesc + "(��עΪ*����ĿΪ������)',headerCls:'panel-header-gray'\" style='width:1280px;padding:0px 5px 5px 5px;'>"
                      	+"		<div id='DIV" + TypeID + "' style='margin:0px 10px 0px 10px;'></div>"
        				+"</div>"
        				+"<div style='padding-bottom:10px;'></div>";
      	obj.SumID++;
    }
    //�������(δ������˹۲�����)ֻ��ʾ����
    if(ExtTypeIDs_2.total==0){
		html_2 = html_2 +"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"��׷�ټ��" + "(��עΪ*����ĿΪ������)',headerCls:'panel-header-gray'\" style='width:1280px;padding:0px 5px 5px 5px;'>"
                      	+"		<div id='LabDIV' style='margin:0px 10px 0px 10px;padding-top:5px;'>123456</div>"
        				+"</div>"
        				+"<div style='padding-bottom:10px;'></div>";
      	obj.SumID++;
	}
    $('#OccInfo_2').html(html_2)
    $.parser.parse('#OccInfo_2'); 		// ����ҳǩ2
    
    //����ҳǩ[�ܹ�]:�������(��ϸ���ĵ�)
     var ExtTypeIDs= $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryExpRegType",
        aRegTypeID: RegTypeID,
        rows:999
    }, false);
	for (var ind = 0; ind < ExtTypeIDs.total;ind++) {
        var ExtTypeData = ExtTypeIDs.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var Data = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryExtByType",
            aTypeID: RegTypeID,
            aExtTypeID: TypeID,
            rows:999
        }, false);
      	//(�洢��ʱ����)  
    	var arr="";		
        //��ȡ��Ŀ�б�
        for(var jnd = 0; jnd < Data.total; jnd++) {
            var ItemData = Data.rows[jnd];
            var Code = ItemData.Code;  	
            var BoxID = TypeID+"-"+parseInt(Code.substring(2,4));
            //�����ظ�ֵ
            if(arr.indexOf(BoxID)>-1) continue;
            arr=arr+"^"+BoxID;
        }
        for(var knd = 1; knd < arr.split("^").length; knd++){
	    	var BoxID = arr.split("^")[knd];
	    	
	    	//����Box
	    	var SLine="";
	    	if(knd<(arr.split("^").length-1)){
		    	//var SLine=SLine='<span class="line" style="display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;"></span>';
		    }
            
            var html 	= 	'<div id="Box'+BoxID+'" style="padding-top:8px;padding-bottom:4px;">'
                    	+ 	'	<div id="Box'+BoxID+'-1"></div>'	//�����[XX01XX]
                    	+	'	<div style="clear:both;"></div>'	//�������
                        + 	'	<div id="Box'+BoxID+'-2""></div>'	//������[XX0101]
                      	+ 	'</div>'
                       	+ 	SLine;
           	$("#DIV" + TypeID).append(html);
	    }
    }
    //����ҳǩ[����]:�������(��ϸ���ĵ�)--���䡢����....
    for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
        var ExtTypeData = ExtTypeIDs.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;	//��¶��Ϣ����¶Դ��Ϣ
        var Data = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryExtByType",
            aTypeID: RegTypeID,
            aExtTypeID: TypeID,
            rows:999
        }, false);
        for (var jnd = 0; jnd < Data.total; jnd++) {
            var ItemData = Data.rows[jnd];	//���䡢ְ��...

            var ID = ItemData.ID.split("||")[1];//1
            var Code = ItemData.Code;			//020110
            var Desc = ItemData.Desc			//����
           	var DataType = ItemData.DatCode;  	//�ı�����ѡ�򡢶�ѡ��
            var DicCode = ItemData.DicCode;   	//OEWorkAge
            var Required = ItemData.IsRequired; //1
           	
           	var IsItemExt = parseInt(Code.substring(5));		//�Ƿ����䱸ע
           	var ExtID=1;
         	if(IsItemExt!=0)ExtID=2;
	        //BoxID(����Box)
	        var BoxID = TypeID+"-"+parseInt(Code.substring(2,4))+"-"+ExtID;
	        
	        var ItemID = parseInt(Code);
	        //����Ӵ�(������)*
          	var Label = "";
          	if (Required == 1) {
            		Label = "<strong><font color='red'>*</font></strong>" + Desc;
          	}
           	else {
         		Label = Desc;
         	}
         	Label=$g(Label);  //�����Ը���
	     	//(1):��������
	     	if (DataType == "") {   	
       			var html='<div id="'+ItemID+'"><b>' + Label + '</b></div>'
           		
				// if(Label.indexOf("ְҵʷ")>-1||Label.indexOf("ְҵ�Ӵ������")>-1){
				// 	html+='<a style="padding-left:50px;" id="btn-add" href="#" class="easyui-linkbutton" data-options="iconCls:'+"icon-Add"+'" onclick="obj.Add('+"'"+Label+"'"+')">����</a>';
				// 	html+='<a style="padding-left:50px;"id="btn-del" href="#" class="easyui-linkbutton" data-options="iconCls:'+"icon-remove"+'" onclick="obj.del('+"'"+Label+"'"+')">ɾ��</a>';
					
				// }
				$("#Box"+BoxID).append(html);
       		}
            //(2):��ѡ�ֵ�
	      	else if (DataType == "DS") {  //��ѡ�ֵ�
             	var html 	= 	'<div id="div_'+ ItemID + '">'
           					+	'	<div><b>' + Label + '</b></div>'	//����
                            + 	'	<div id="' + ItemID + '"></div>'	//��ѡ�б�
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//�������
				$("#Box"+BoxID).append(html);  
				//���ص�ѡ�б�(Ĭ��4��)
                Common_RadioToDic(ItemID, DicCode, 4);		
            }
            //(3):��ѡ���ֵ�
            else if (DataType == "DSL") {
            	var html 	= 	'<div>'
               				+	'	<div><b>' + Label + '</b></div>'	//����
                           	+ 	'	<div id="' + ItemID + '"></div>'	//��ѡ�б�
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//�������
            	$("#Box"+BoxID).append(html);  
            	//���ص�ѡ�б�(Ĭ��2��)
                Common_RadioToDic(ItemID, DicCode, 2);		
            }
            //(4):��ѡ�ֵ�
            else if (DataType == "DB") {  
            	var html 	= 	'<div>'
                			+	'	<div><b>' + Label + '</b></div>'	//����
                           	+ 	'	<div id="' + ItemID + '"></div>'	//��ѡ�б�
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//�������
            	$("#Box"+BoxID).append(html); 
            	//���ض�ѡ�б� (Ĭ��4��)
               	Common_CheckboxToDic(ItemID, DicCode, 4);		
           	}
            //(5):��ѡ���ֵ�
            else if (DataType == "DBL") { 
            	var html 	= 	'<div>'
               				+	'	<div><b>' + Label + '</b></div>'	//����
                           	+ 	'	<div id="' + ItemID + '"></div>'	//��ѡ�б�
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//�������
            	$("#Box"+BoxID).append(html); 
            	//���ض�ѡ�б� (Ĭ��2��)
               	Common_CheckboxToDic(ItemID, DicCode, 2);
            }
           	//(6):����|�Ƿ�
            else if ((DataType == "B1") || (DataType == "B2")) {
            	var html 	= 	'<div id="div_'+ ItemID + '">'
               				+	'	<div><b>' + Label + '</b></div>'	//����
                           	+ 	'	<div id="' + ItemID + '"></div>'	//��ѡ�б�
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//�������
            	$("#Box"+BoxID).append(html); 
            	//�����Ƿ�|����;  
               	Common_RadioToDic(ItemID, DicCode, 4);
            }
            //(7):���ı�
            else if (DataType == "TL") { 
            	var html 	= 	'<div>'
                			+	'	<div><b>' + Label + '</b></div>'
                        	+ 	'	<div><textarea class="textbox" id="' + ItemID + '" style="width:1170px; height: 80px;""></textarea></div>'
                           	+ 	'</div>'
            	$("#Box"+BoxID).append(html); 
           	 }
           	 //(8):������
           	 else if (DataType == "S") {    
            	var html=	'<div style="float:left;width:25%;">'
						+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'	//����
						+	'	<input class="hisui-combobox textbox" id="' + ItemID + '" style="width:187px;" />'	//�����б�
						+	'</div>';
            	$("#Box"+BoxID).append(html);  
            		
                $.parser.parse("#Box"+BoxID); // ������ҳ��
            	Common_ComboDicID(ItemID, DicCode,1);  //��������
          	}
          	//(9):�ı�����ֵ
           	if ((DataType == "T") || (DataType == "N0") || (DataType == "N1")) {
	           	if(Code=="050130"){
		        	var html=	'<div style="float:left;width:50%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 430px;" />'
							+	'</div>';
		        }
		        else{
			    	var html=	'<div id="div_'+ ItemID + '" style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 180px;" />'
							+	'</div>';
			    }
            	
				
            	$("#Box"+BoxID).append(html);   
        	}
          	if (DataType == "TB") {   //���ı�	
            	var html=	'<div style="padding-left:5px;">'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 1060px;" placeholder="' + Label + '..."/>'
							+	'</div>';
            	$("#Box"+BoxID).append(html);  
                 $.parser.parse("#Box"+BoxID); // ������ҳ�� 
        	}
           	if (DataType == "DD") {  //����
            	var html=	'<div style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class=\'hisui-datebox textbox\' id="' + ItemID + '"style="width:187px;"/></div>'
							+	'</div>';
           		$("#Box"+BoxID).append(html); 
           		$.parser.parse("#Box"+BoxID); // ������ҳ�� 
       		}
            if (DataType=="DST"){
                 // ��ѡ�ı�
                 var html    =   '<div>'
                            +   '   <div><b>' + Label + '</b></div>'    //����
                            +   '   <div id="' + ItemID + '"></div>'    //��ѡ�б�
                            +   '</div>'
                            // +   '   <input class="textbox" id="' + ItemID + '" style="width: 430px;" />'
                            +   '<div style="clear:both;"></div>'   //�������
                $("#Box"+BoxID).append(html);  
                //���ص�ѡ�б�(Ĭ��2��)
                //Common_RadioToDic(ItemID, DicCode, 2); 
                Common_RadioTextToDic(ItemID, DicCode, 2,1); 
				debugger
				//��ѡ���¼�
				if (obj.BTSCheck==1) {
					$HUI.radio("[name='"+ItemID+"']", {
						onChecked: function () {
							var nextInput=$(this).next().next()
							var _name=$(this).attr("name")
							
							var _text=nextInput.val();
							var _id=nextInput[0].id
							nextInput.focus();
							_text=$.trim(_text)
							if (_text!=""){
								// ��Ȼ�Ѿ���ֵ,ͬ��Ϊ��
								
								$("input[id^='"+_name+"']").each(function () {
									if ($(this)[0].id!=_id){
										$(this).val("");
									}
			����				}) 
							}
						}
					});
					$("input[id^='"+ItemID+"']").each(function () {
						var _this=$(this);
						$(this).blur(function(){
							var _value=_this.val();
							_value=$.trim(_value)
							var rId=_this.prevAll("input")[0]
							if (_value!="") {
								//����ѡ���¼�
								
								 $HUI.radio(rId).setValue(true);
							}
						})
����				}) 
				}//������ѡ���¼�
            }
        }
    }
    //���ؼ�����
    var Html 	="<div style='padding-left:50px;padding-top:5px;'><input id='chkHBV' type='checkbox' class='hisui-checkbox' label='HBV' name='chkLab' value='HBV'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    			+"<input id='chkHCV' type='checkbox' class='hisui-checkbox' label='HCV' name='chkLab' value='HCV'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    			+"<input id='chkHIV' type='checkbox' class='hisui-checkbox' label='HIV' name='chkLab' value='HIV'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp";
    if(obj.RegTypeDesc.indexOf("ѪԴ��")<0){
		var Html=Html+"<input id='chkMD' type='checkbox' class='hisui-checkbox' label='÷��' name='chkLab' value='MD'></div>";
	}

    var Html=Html+'<span id="LineLab" class="line" style="display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;"></span>';
    var Html=Html+"<div id='LabData'><table class='report-tab'>";
    var LabList = $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryOccExpTypeLab",
        aTypeID: RegTypeID,
		aIsActive:1,
		rows:999
    }, false);
    for (var i = 0; i < LabList.total; i++) {
        var LabData = LabList.rows[i];
        var ID = LabData.ID;
        var BTDesc = LabData.BTDesc;
        var BTDays = LabData.BTDays;
        var Resume = LabData.Resume;
        var SubID = ID.split("||")[1];
		var LabType=LabData.LabType;
		
        var Html = Html + '	<tr id="'+LabType+"_"+SubID+'" class="report-tr">'
                        + '		<td style="padding-left:50px;">' + BTDesc + '</td>'
                        + '		<td class="report-td">' + Resume + '</td>'
                        + '		<td class="report-td">��������</td>'
                        + '		<td><input class="hisui-datebox textbox" id="dtLabDate' + SubID + '" style="width: 200px; " /></td>'
                        + '		<td class="report-td">������Ŀ</td>'
                        + '		<td><input class="textbox" id="txtLabItem' + SubID + '" style="width: 200px; " /></td>'
                        + '		<td class="report-td">������</td>'
                        //������
                        + '		<td><input class="textbox" id="cboLabResult' + SubID + '" style="width: 200px; " /></td>'
                        //�ı���
                        //+ '		<td><input class="textbox" id="cboLabResult' + SubID + '" style="width: 200px; " /></td>'
                        + '	</tr>';
    }
    var Html = Html + '</table></div>';
    
    $('#LabDIV').html(Html);
    $.parser.parse('#LabDIV');
    //���������
    for (var i = 0; i < LabList.total; i++) {
        var LabData = LabList.rows[i];
        var ID = LabData.ID;
        var SubID = ID.split("||")[1];
        
        $HUI.combobox("#cboLabResult"+SubID, {
			editable: true,
			allowNull: true, 
			valueField: 'value',
			textField: 'text',
			data: [
				{ value: '1', text: '����' },
				{ value: '2', text: '����' },
				{ value: '3', text: '����' }
        	]
		});
    }
    $('#LabData').hide();	//Ĭ������
    $('#LineLab').hide();	//Ĭ������
    $('.line').css("padding-bottom","5px");
    
    InitFloatWin();			//���ذ���ҳ��
    InitReportWinEvent(obj);
    obj.LoadEvent();
    return obj;
}