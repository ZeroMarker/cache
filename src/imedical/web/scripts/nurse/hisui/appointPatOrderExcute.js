/**
 * @author wujiang 
 * @description ԤסԺ��ʿִ�н��� 20200217
 */
var GV = {
    tabCode:'',
    barcodeLengthConfig:'',//����ų���
    columns:'',
    orders:[],
    originalOrder:[],
    patEncrypt:{}, //�����ܼ�
    buttons:[],
    mutiplyColumns:{}
}
var commonTimer; //����timer
var exeBtnInfo; //��ť��Ϣ
var functionName='excuteOrder'; // ��������
var keyword=''; // �����ؼ���
var exeDateTime=''; // ִ�е�����ʱ��
var fuzzyKeyword=''; // �����ؼ���
var curPrintFlag=''; // ��ǰ��ӡ��ʶ��
var curCheckFlag=''; // ��ǰѡ�б�ʶ
var columnKeys=[]; // �еļ�ֵ
var treegridObj;
var selectAllFlag=0;
var regNoLength=0;//��¼�ǼǺų��ȣ����ڲ�0
var disposeStates=$cm({
    ClassName: 'Nur.NIS.Service.OrderExcute.QueryOrder',
    MethodName: "GetDisposeStateInfo",
    hospId:session["LOGON.HOSPID"]
}, false)
var disposeStateSets={};
for (var item in disposeStates){
	disposeStateSets[item]=disposeStates[item].desc;
}
var prtConfig;
$cm({
    ClassName: "Nur.NIS.Service.OrderExcute.NurPrintBusiness",
    MethodName: "GetPrtConfig",
    hospId: session["LOGON.HOSPID"]
},function(ret) {
    prtConfig = ret;    
})
disposeStateSets["Temp"]=$g("��ִ��");
/*var disposeStateSets= {
        LongUnnew: "���³���",
        LongNew: "�¿�����",
        Temp: "��ִ��",
        Immediate: "�账����",
        TempTest: "�����账��",
        SkinTest: "Ƥ��ҽ��",
        Discontinue: "��ִֹͣ��",
        ExecDiscon: "��ִֹͣ��",
        Exec: "��ִ��",
        NeedToDeal: "�账��",
        NeedToStop: "ֹͣ�账��",
        AlreadyDeal: "�Ѵ���",
        AlreadyStop: "ֹͣ�Ѵ���",
        RefuseDispDrug: "ҩ���ܷ�ҩ",
        SpecmentReject: "�������"
    }*/
/*-----------------------------------------------------------*/
var init = function () {
    initEvent();
    initBasicData();
    // ��ʼ��HISUI����
    initEditWindow();
    $("#patSearch-Panel").panel({
	    onResize:function(width, height){
		    setTimeout(function(){
			    $('#orderTable').treegrid("resize",{
					width:$(".content").width(),
					height:$(".content").next().height(),
				});
			})
		}
	});
}
$(init)
$(window).load(function() {
    $("#loading").hide();
})

// ��ȡ���ݶ�Ӧ������Ϣ
function getSheetColumns() {
    $cm({
        ClassName: 'Nur.NIS.Service.OrderExcute.QueryOrder',
        MethodName: "GetSheetColumns",
        sheetCode:GV.tabCode, 
        hospId:session["LOGON.HOSPID"]
        // hostpitalID:0
    }, function (jsonData) {
        GV.columns=jsonData
        // var columns=[{checkbox:true}],
        var columns=[], comboData=[] //ѡ����˵Ĺؼ���    
        columnKeys=[]    
        jsonData.map(function(elem) {
            comboData.push({
                key:elem.key,
                title:elem.title,
                selected:'��ҩ;��'==elem.title?true:false
            })
            if (elem.key==='arcimDesc') {
                columns.push({
                    field:'handleState',
                    title:'����״̬',
                    width:'120'
                })
            }
            if (JSON.parse(elem.multiply)) {
                columns.push({
                    field:'bunch-'+elem.key,
                    title:'',
                    width:'20'
                })
				GV.mutiplyColumns[elem.key]=1;
            }
			// key: "notes"
			// multiply: "true"
			// title: "��ע"
			// width: "200"            
            columns.push({
                field:elem.key,
                title:elem.title,
                width:parseInt(elem.width) + 16,
                align:"left",
                formatter:function(value, row, index){
                    if (elem.key == "arcimDesc") {
		                if (row.appendOrder) {
			                value+"(����ҽ����"+row.appendOrder+")"
			            }
			            if ((row.ordExecCA =="Y")){ //(row.ordItemCA =="Y")||
				            value = '<img style="vertical-align:-3px;padding-right:5px;" src="../images/uiimages/ca_icon.png"/>'+value;
				        }
			            return value;
		            }else{
			            return value;
			        }
                    /*if (("arcimDesc"==elem.key)&&row.appendOrder) {
                        return value+"(����ҽ����"+row.appendOrder+")"
                    } else {
                        return value;
                    }*/
                }
            })
            if ('placerNo'!=elem.key) {
                columnKeys.push(elem.key)
            }
        });
        $HUI.combobox("#titleBox",{
            valueField:'key', textField:'title',panelHeight:"250",
            data:comboData,
            defaultFilter:4
        });
        /*var contentHeight=$('.right>.content').css('height')
        var operateHeight=$('.right>.content>.operate').css('height')
        var tableHeight=parseInt(contentHeight)-parseInt(operateHeight)*/
        var tableHeight=$(window).height()-97;
        $HUI.checkbox("input#selectAll").setValue(false);
        treegridObj = $HUI.treegrid('#orderTable',{
            onUncheckAll:function(nodes){
                if (1==selectAllFlag) {
                    // ������Ӧjs��ֵ���¼�
                    selectAllFlag=0;
                    return;
                }
                setTimeout(function(){
                    var flag=true;
                    nodes.map(function(node) {
                        flag=flag&&(node.checked||false);
                    })
                    selectAllFlag=2;
                    $HUI.checkbox("input#selectAll").setValue(flag);
                    selectAllFlag=0;
                },300);
            },
            autoSizeColumn:false,
            checkbox:true,
            columns:[columns],
            treeField:'arcimDesc',
            idField:'rowKey',
            headerCls:'panel-header-gray',
            height:tableHeight,
            border:false,
            onLoadSuccess:function(row, data){
                $("#orderTable").treegrid("collapseAll");
            }
        })
        getOrders();
    });
}
// ��ȡ���ݶ�Ӧ������Ϣ
function selectAll(e,flag) {
    if (2==selectAllFlag) {
        // ������Ӧjs��ֵ���¼�
        selectAllFlag=0;
        return;
    } else {
        selectAllFlag=1;
    }
    if (flag) {
        GV.orders.map(function(elem,index) {
            $('#orderTable').treegrid('checkNode',elem.rowKey)
        })
    } else {
        treegridObj.clearChecked();
    }
    selectAllFlag=0;
}
/**
 * @description ��ʼ����������
 */
function initBasicData() {
    $('#appStartDate').datebox('setValue', dateCalculate(new Date(), appointManageSet.StartDate?appointManageSet.StartDate:0));//dateCalculate(new Date(), -18)
    $('#appEndDate').datebox('setValue', dateCalculate(new Date(), appointManageSet.EndDate?appointManageSet.EndDate:0)); //formatDate(new Date())
    $('#bookDocBox').combobox({
        valueField: 'ID',
        textField: 'name',
    });
    $('#appLocBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.CommonInterface.Loc&MethodName=getLocs&locType=E',
        onSelect: function (record) {
            $('#bookDocBox').combobox('clear');
            $('#bookDocBox').combobox('options').url = $URL + '?ClassName=Nur.CommonInterface.Ward&MethodName=getMainDoctors&locID=' + record.ID;
            $('#bookDocBox').combobox('reload');
        },
        onChange:function(desc,val){
            if(!desc&&val==""){
                $('#bookDocBox').combobox('clear');
                $('#bookDocBox').combobox('loadData', {});//���optionѡ��   
            }
        },
        filter: function (q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
            var pyjp =getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        },
        onLoadSuccess:function(){
	        /*if ((CTLocType=="W")&&(IsDaySurgeryLoc=="N")&&(WARDBeforehand!="Y")&&(WardLinkLocNum<=1)){
		        $('#appLocBox').combobox("select",WardLinkLocId).combobox('disable');
		    }*/
	    },
	    loadFilter:function(data){
		    //����½����Ϊ�ռ��������ң���ɲ鿴��ִ�У��ռ��������Ҽ���������ҵ�ȫ������ҽ��
		    if (IsDaySurgeryLoc =="Y"){
			    var newData=[];
			    for (var i=0;i<data.length;i++){
				    if ((("^"+DaySurgeryLinkLocStr+"^").indexOf("^"+data[i].ID+"^")>=0)||(data[i].ID==session['LOGON.CTLOCID'])){
					    newData.push(data[i]);
					}
				}
				return newData;
			}else{
				return data;
			}
		}
    });
    $('#appWardBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.CommonInterface.Loc&MethodName=getLocs&locType=W',
        onLoadSuccess:function(){
            /*var data=$('#appWardBox').combobox('getData');
            var locId=session['LOGON.CTLOCID'];
            data.map(function(e) {
                if (locId==e.ID) {
                    // ����Ĭ�ϲ���
                    $("#appWardBox").combobox("setValue",locId);
                }
            })*/
            //����½����Ϊ������ward�������߲�ѯ�б�ֻ��ѯ���������ˣ�ֻ��ִ�б���������ҽ��
	        //����½����Ϊ�ռ��������ң���ɲ鿴��ִ�У��ռ��������Ҽ���������ҵ�ȫ������ҽ��
	        if ((CTLocType=="W")&&(IsDaySurgeryLoc=="N")&&(WARDBeforehand!="Y")){
		       $('#appWardBox').combobox("select",session['LOGON.CTLOCID']).combobox('disable');
		    }
            InitAppPatGrid();
        },
        filter: function (q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
            var pyjp =getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        },
	    loadFilter:function(data){
		    //
		    //����½����Ϊ�ռ��������ң���ɲ鿴��ִ�У��ռ��������Ҽ���������ҵ�ȫ������ҽ��
		    if (IsDaySurgeryLoc =="Y"){
			    var newData=[];
			    for (var i=0;i<data.length;i++){
				    var FindFlag=0;
				    var locLinkWards=data[i].locLinkWards;
				    for (var j=0;j<locLinkWards.length;j++){
					    if ((("^"+DaySurgeryLinkLocStr+"^").indexOf("^"+locLinkWards[j].docLocID+"^")>=0)||(locLinkWards[j].docLocID==session['LOGON.CTLOCID'])){
						    FindFlag=1;
						    break;
						}
					}
					if (FindFlag ==1) newData.push(data[i]);
				}
				return newData;
			}else{
				return data;
			}
		}
    })
    // ��ȡtabs��ǩ
    $cm({
        ClassName: 'Nur.CommonInterface.OrderSheet',
        MethodName: "getSheetsOfSSGroup",
        groupID:session["LOGON.GROUPID"],
        ctLoc:session["LOGON.CTLOCID"],
        preHosFlag:1
    }, function (data) {
        GV.tabData=data
        // "code":"WZX",
        // "default":"1",
        // "desc":"δִ��*",
        // "hospitalID":"0"
        $('#opeTabs').tabs('add',{
            title: 'ԤסԺ��ʿִ��'
            //iconCls:'icon icon-paper-blue-line'
        });
        // <span class="icon icon-paper-blue-line">icon-paper-blue-line</span>
        var selIndex=0;
        data.map(function(elem,index) {
            if (elem.default) selIndex=index;
            $('#opeTabs').tabs('add',{
                title: elem.desc
            });
        });
        $HUI.tabs("#opeTabs",{
            onSelect:function(title,index){
                $HUI.checkbox('#excuteCheck').setValue(false)
                $HUI.checkbox('#printCheck').setValue(false)
                $('#fuzzyKeyword').searchbox('setValue','');
                GV.tabCode=data[index-1].code
                getSheetColumns()      
            }
        });
        $('#opeTabs').tabs('select',selIndex+1);
    });
    // ��ȡ�����ܼ���Ϣ
    $cm({
        ClassName: 'Nur.NIS.Common.Collections',
        MethodName: "GetEncryptInfo"
    }, function (data) {
        data.map(function(item) {
            GV.patEncrypt[item.alias]=item.desc;
        })
    })
    // ��ȡ����ų�������
    $.get('dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.INCSysCounter&pClassMethod=OpenData', function(res) {
        res=eval(res)
        GV.barcodeLengthConfig=res[0].LabtrakNumberLength;
    })
    //calcPageHeight()
}
function calcPageHeight() {
    $("#patSearch-Panel").panel('resize',{
        height: $(window).height() - 8
    });    
    // ���û����б��div�߶�
    $("#patShowList").css({
        height:$(window).height() - 250
    });
    $('#orderTable').datagrid('resize');
    var containerHeight=$('body>.container').css('height')
    $('.container > .right').css('height', containerHeight);
}
// ��ȡ���ݶ�Ӧ�İ�ť��Ϣ
function getSheetButtons() {
    $cm({
        //ClassName: 'Nur.NIS.Service.OrderExcute.Execute',
        ClassName: 'Nur.NIS.Service.OrderExcute.QueryOrder',
        MethodName: "GetSheetButtons",
        hospId:session["LOGON.HOSPID"],
        sheetCode:GV.tabCode,
        //ctLoc:session["LOGON.CTLOCID"],
        excuteOrderFlag:$HUI.checkbox('#excuteCheck').getValue(),
        //printedOrderFlag:$HUI.checkbox('#printCheck').getValue()
    }, function (data) {
        GV.buttons=data;
        var dynamic=$('.operate>.dynamic')
        dynamic.empty()
        if (data.length) {
            dynamic.show()
        } else {
            dynamic.hide()
        }
        data.map(function(elem,index) {
	        //debugger;
	       	if (elem.jsFunction!="stopExcuteOrder") {
	            if ('lisBarPrintMerge'==elem.jsFunction) {
	                data[index].jsFunction="lisBarPrint"
	            }
	            if (elem.formWorkId) {
		        	dynamic.append('<a class="hisui-linkbutton hover-dark" onclick="'+elem.jsFunction+'('+elem.formWorkId+',\''+elem.printFlag+'\');">'+elem.name+'</a>')
		        }else{
			    	dynamic.append('<a class="hisui-linkbutton hover-dark" onclick="'+elem.jsFunction+'();">'+elem.name+'</a>')
			    }
	            
	            if (elem.printFlag) {
	                var n=0
	                GV.orders.map(function(e) {
	                    if (e.execInfos) {
	                        e.execInfos.map(function(e2) {
	                            if (e2.printFlag !="undefined" &&(e2.printFlag.indexOf(elem.printFlag)<0)) {
	                                n++;//�ҳ���û��ӡ��
	                            }
	                        });
	                    }
	                });
	                if (n) {
	                    dynamic.append('<span onclick="toggleAndFilterOrder(\''+elem.printFlag+'\','+n+')" class="unPrintNum">'+n+'</span>');
	                    //dynamic.append('<a onclick="toggleAndFilterOrder(\''+elem.printFlag+'\','+n+')" class="unPrintNum">'+n+'</a>');
	                }
	            }
            }
        });
        dynamic.children(".hisui-linkbutton").linkbutton({});
        //calcPageHeight();//����ҳ��߶�
        if (HISUIStyleCode=="lite"){
		    $(".unPrintNum").addClass("unPrintNum-Lite");
		    dynamic.children(".hisui-linkbutton").css("border-radius","2px 0 0 2px")
		}
    });
}
// CAǩ����֤
function caSignVerify() {
    var desc, windowModel, orderIDObj, queryOrder;
    // GV.buttons.map(function(e) {
    //     if (functionName==e.jsFunction) {
    //         desc=e.name;
    //         if (JSON.parse(e.ifShowWindow)) {
    //             windowModel="W";
    //             if (JSON.parse(e.ifSign)) {
    //                 windowModel="S";
    //                 if (JSON.parse(e.ifDBSign)) {
    //                     windowModel="D";
    //                 }
    //             }
    //         } else {
    //             windowModel="N";
    //         }
    //     }
    // })
    // ��ȡbutton��ť��Ϣ��ҽ��������Ϣ
    if (!exeBtnInfo) {
        var btnData=$cm({
          ClassName: 'Nur.NIS.Service.OrderExcute.SheetConfig',
          QueryName: 'GetAllExecuteButton',
          rows: 999999999999999,
          hospId: session["LOGON.HOSPID"]
        }, false);
        exeBtnInfo={};
        btnData.rows.map(function(e) {
            exeBtnInfo[e.Func]=e;
        })

    }
    if (exeBtnInfo[functionName]) {
        var e=exeBtnInfo[functionName];
        desc=e.Name;
        if ("Y"==e.ShowWin) {
            windowModel="W";
            if ("Y"==e.Sign) {
                windowModel="S";
            }
        } else {
            windowModel="N";
        }
    }
    // if (exeDateTime.valueOf()>(new Date()).valueOf()) {
    //     $.messager.popover({msg:'���������ʱ�䲻�ܴ��ڵ�ǰʱ�䡣',type:'alert'});
    //     return;
    // }
    var nodes=treegridObj.getCheckedNodes('checked')
    var oeoreIds=[];
    var doubleExec = [];
    nodes.map(function(elem,index) {
        if (!elem.execInfos) {
	        var findDoubleExec=0;
	        for (var l=0;l<elem.ID.split("^").length;l++){
		        var execId=elem.ID.split("^")[l];
		        oeoreIds.push(execId);
		        if (findDoubleExec==0){
			        var index=$.hisui.indexOfArray(GV.originalOrder,"ID",execId.split("||")[0]+"||"+execId.split("||")[1]);
				    if (index>=0){
				        if (GV.originalOrder[index].doubleSign === "Y") {
				            findDoubleExec=1;
				        }
				    }
			    }
		    }
		    if (findDoubleExec==1){
			    doubleExec=doubleExec.concat(elem.ID.split("^"));
			}
            /*(function() {
                var e=elem;
                if (windowModel=="S") {
                    // �ж�ҽ���Ƿ���Ҫ˫ǩ
                    var dbSignFlag=$cm({
                      ClassName: 'Nur.NIS.Service.OrderExcute.QueryOrder',
                      MethodName: 'IsDoubleSignOrderGroup',
                      dataType: "text",
                      oeordID: e.ID.split("||")[0],
                      oeoriSub: e.ID.split("||")[1],
                      hospID: session["LOGON.HOSPID"]
                    }, false);
                    if ("Y"==dbSignFlag) windowModel="D"
                }
            })();*/
        }
    });
    if (doubleExec.length === oeoreIds.length && windowModel=="S") {
       windowModel="D"
    }
    var orderIDObj={};
    
    if ('excuteOrder'==functionName) {
        orderIDObj['execOrderList']=oeoreIds;
        orderIDObj['execDisOrderList']=[];
    } else if ('cancelOrder'==functionName) {
        orderIDObj['cancelExecOrderList']=oeoreIds;
    }
    handleOrderCom(functionName, desc, windowModel, "false",orderIDObj, UpdateOrdGroupChunks, "NUR");
}
//�жϻ����Ƿ�ԤԼ���ִ�״̬
function checkBookAppStatus()
{
	var rtn=$cm({
      ClassName: 'Nur.InService.AppointManage',
      MethodName: 'getBookAppointStatus',
      episodeID: GV.episodeID
    }, false);
	if ((appointManageSet.UnAppointNotAllowExecOrd=="Y")&&(rtn.appointFlag!="Y")){
		$.messager.popover({ msg: "����δԤԼ��", type:'error' });
		return false;
	}
	if ((appointManageSet.UnAllocateNotAllowExecOrd=="Y")&&(rtn.allocateFlag!="Y")){
		$.messager.popover({ msg: "����δ�ִ���", type:'error' });
		return false;
	}
	return true;
}
// ִ�ж���
function excuteOrder(flag) {
	//�жϻ����Ƿ�ԤԼ���ִ�״̬
	if (!checkBookAppStatus()) return false;
    // if (flag) {
        if (treegridObj.getCheckedNodes('checked').length) {
            functionName='excuteOrder';
            if (treegridObj.getCheckedNodes('checked').length) {
	             var needPrintSheetCode = ['JYD','WZX'];
	             if (needPrintSheetCode.indexOf(GV.tabCode)>-1) {
	                 var execNotPrint = [];
	                 var execIDNotPrint = [];
	                 treegridObj.getCheckedNodes('checked').map(function(elem) {
	                     if (!elem.execInfos) {
	                         if (elem.printFlag.indexOf('P')<0 && elem.labOrdExecNeedPrintedFlag=="Y") {
		                         if (execNotPrint.length < 10) {
				                    if (execIDNotPrint.indexOf(elem.ID) < 0) {
				                      execIDNotPrint.push(elem.ID);
				                      execNotPrint.push(elem.parentArcimDesc.split("<span")[0]);
				                    }
				                 } else if (execNotPrint.length === 10) {
				                    execNotPrint.push("......");
				                 }
	                         }
	                     }
	                 });
	                 if (execNotPrint.length !== 0) {
		                  $.messager.popover({msg:execNotPrint.join(" ")+'��δ��ӡ���룡',type:'alert'});
					      return;
					 }
	             }
	         }
            caSignVerify();
            return;
            var date=$('#exeDate').datebox('getValue'),time=$('#exeTime').timespinner('getValue')
            if (date&&time) {
                var workNo=$("#workNo").val(),password=$("#exePassword").val()
                $cm({
                    ClassName: 'Nur.NIS.Service.Base.User',
                    MethodName: "ordexePasswordConfirm",
                    userCode:workNo,
                    passWord:password,
                    ctLoc:'',
                }, function (data) {
                    if (0==data.result) {
                        // UpdateOrdGroupChunks()
                        caSignVerify();
                    } else {
                        $.messager.popover({msg:data.result,type:'alert'});
                    }
                })
            } else {
                $.messager.popover({msg:'��ѡ������ʱ�䣡',type:'alert'});
            }
        } else {
            $.messager.popover({msg:'����ѡ��ҽ����',type:'alert'});
        }
    // } else {
    //     if (treegridObj.getCheckedNodes('checked').length) {
    //         var needPrintSheetCode = ['JYD'];
    //         if (needPrintSheetCode.indexOf(GV.tabCode)>-1) {
    //             var flag=false;
    //             treegridObj.getCheckedNodes('checked').map(function(elem) {
    //                 if (!elem.execInfos) {
    //                     if (elem.printFlag.indexOf('P')<0) {
    //                         flag=true;
    //                         $.messager.popover({msg:elem.parentArcimDesc+'��δ��ӡ��',type:'alert'});
    //                     }
    //                 }
    //             });
    //             if (flag) {return;}
    //         }
    //         functionName='excuteOrder'
    //         exeDateTime=new Date()
    //         $('#exeDate').datebox('setValue', formatDate(exeDateTime));
    //         $("#exeTime").timespinner('setValue', exeDateTime.toTimeString().slice(0, 5));  //��ֵ
    //         $("#remark,#exePassword").val('')
    //         $("#workNo").val(session["LOGON.USERCODE"])
    //         $HUI.dialog('#exeModal').open();
    //     } else {
    //         $.messager.popover({msg:'����ѡ��ҽ����',type:'alert'});
    //     }
    // }
}
// ��¼ִ������ʱ��
function recordExeDateTime(date) {
    var time=$("#exeTime").timespinner('getValue')
    if (new Date(date).valueOf()) {
        exeDateTime=date
    }
    if (!exeDateTime) exeDateTime=new Date();
    var month=(exeDateTime.getMonth()+1).toString();
    if (month.length<2) {month="0"+month}
    var day=exeDateTime.getDate().toString();
    if (day.length<2) {day="0"+day}
    var dateTime=exeDateTime.getFullYear()+'-'+month+'-'+day+' '+time
    exeDateTime=new Date(dateTime)
}
// ����ִ��
function cancelOrder(flag) {
    // if (flag) {
        if (treegridObj.getCheckedNodes('checked').length) {
            functionName='cancelOrder';
            caSignVerify();
            return;
            var date=$('#exeDate').datebox('getValue'),time=$('#exeTime').timespinner('getValue')
            if (date&&time) {
                caSignVerify();
            } else {
                $.messager.popover({msg:'��ѡ������ʱ�䣡',type:'alert'});
            }
        } else {
            $.messager.popover({msg:'����ѡ��ҽ����',type:'alert'});
        }
    // } else {
    //     if (treegridObj.getCheckedNodes('checked').length) {
    //         functionName='cancelOrder'
    //         $('#exeDate').datebox('setValue', formatDate(new Date()));
    //         $("#exeTime").timespinner('setValue', (new Date()).toTimeString().slice(0, 5));  //��ֵ
    //         $("#remark").val('')
    //         $("table.exeTable tr.workNo,table.exeTable tr.password").hide()
    //         $HUI.dialog('#exeModal').open();
    //     } else {
    //         $.messager.popover({msg:'����ѡ��ҽ����',type:'alert'});
    //     }
    // }
}
// ����ҽ������Ϣ
function UpdateOrdGroupChunks() {
    if (exeDateTime.valueOf()>(new Date()).valueOf()) {
        $.messager.popover({msg:'���������ʱ�䲻�ܴ��ڵ�ǰʱ�䡣',type:'alert'});
        return;
    }
    var nodes=treegridObj.getCheckedNodes('checked')
    var oeoreIds=[]
    nodes.map(function(elem,index) {
        if (!elem.execInfos) {
            oeoreIds.push(elem.ID);
        }
    });
    var execStatusCode={
        excuteOrder:'F',
        cancelOrder:'C',
    }
    $HUI.dialog('#exeModal').close();
    if ('cancelOrder'==functionName) {
        $("table.exeTable tr.workNo,table.exeTable tr.password").show()
    }
    var obj={
        F:"ִ��",
        C:"����ִ��"
    }
    functionName=''
    setTimeout(function(){
        getOrders();
    },2000);
    return;
    $cm({
        ClassName: 'Nur.NIS.Service.Base.OrderHandle',
        MethodName: "UpdateOrdGroupChunks",
        // Ƥ�Ա�ʶ
        setSkinTest:'',
        oeoreIdStr:oeoreIds.join('^'),
        // A���ܣ�R�ܾ���F��ɣ�C����ִ��
        execStatusCode:execStatusCode[functionName]||'F',
        userId:session["LOGON.USERID"],
        userDeptId:session["LOGON.CTLOCID"],
        queryTypeCode:GV.tabCode,
        execDate:$('#exeDate').datebox('getValue'),
        execTime:$("#exeTime").timespinner('getValue'),
        changeReasonDr:$("#remark").val(),
        groupID:session["LOGON.GROUPID"]
    }, function (data) {
        if (0==data.success) {
            $HUI.dialog('#exeModal').close();
            if ('cancelOrder'==functionName) {
                $("table.exeTable tr.workNo,table.exeTable tr.password").show()
            }
            var obj={
                F:"ִ��",
                C:"����ִ��"
            }
            $.messager.popover({msg:obj[execStatusCode[functionName]||'F']+'�ɹ���',type:'success'});
            functionName=''
            setTimeout(function(){
                getOrders();
            },2000);
        } else {
            $.messager.popover({msg:data.errList[0].errInfo,type:'alert'});
        }
    })
}
function splitChunk(arr, size) {
   	var retArr = [];
    for (var i = 0; i < arr.length; i = i + size) {
      retArr.push(arr.slice(i, i + size));
    }
    return retArr;
}
// ��������
function filterByOrdProperty(ord, property, filter) {
    if (
      filter !== "" &&
      ord[property] &&
      filter.indexOf("^" + ord[property] + "^") !== -1
    ) {
      return true;
    } else {
      return false;
    }
}
// ִ�е���ӡ
function sheetPrint(sheetId,flag) {
//	console.log("print");
    var filterByArcimItem = prtConfig["ZXD"] ? prtConfig["ZXD"]["ARCIM"] ? "^" + prtConfig["ZXD"]["ARCIM"] + "^" : "" : "";
    var filterByOhcinDesc = prtConfig["ZXD"] ? prtConfig["ZXD"]["Instr"] ? "^" + prtConfig["ZXD"]["Instr"] + "^" : "" : "";
	var checkedNodes=getAllAndHalfCheckedNodes(),len=checkedNodes.length;
	if (len) {
		var printRange=$('#appStartDate').datebox('getValue') + "��" + $('#appEndDate').datebox('getValue');
		var printUser=session["LOGON.USERNAME"];
		var oeoreID=[],oeoreSeqID=[],episodeID=[],printOeoreID=[];
		
		var seqID=""
		///return false;
		for (var i = 0; i < len; i++) {
            if (checkedNodes[i].execInfos) {
                console.log(checkedNodes[i])
                if (!filterByOrdProperty(checkedNodes[i], "cmArcim", filterByArcimItem) && !filterByOrdProperty(checkedNodes[i], "cmOrdPhcin", filterByOhcinDesc)) {
                    episodeID.push(checkedNodes[i].episodeID);
                    checkedNodes[i].execInfos.forEach(function(item){
                        seqID=item.ID;
                        oeoreID.push(item.ID);
                        oeoreSeqID.push(item.ID);
                        printOeoreID.push(item.ID);
                        if (item.childs && item.childs.length > 0){
                            item.childs.forEach(function(childItem,childIndex) {
                                if (!filterByOrdProperty(item.childsexecInfos[childIndex], "cmArcim", filterByArcimItem) && !filterByOrdProperty(item.childsexecInfos[childIndex], "cmOrdPhcin", filterByOhcinDesc)) {
                                    oeoreID.push(childItem);
                                    oeoreSeqID.push(item.ID);
                                }
                            })
                        }		            
                    });
                }
            }
        	if (checkedNodes[i].sameLabNoOrders && checkedNodes[i].sameLabNoOrders.length >0) {
				checkedNodes[i].sameLabNoOrders.forEach(function(item){
					//printOeoreID.push(item.ID);
					//oeoreID.push(item.ID);
					if (item.execInfos && item.execInfos.length>0){
						item.execInfos.forEach(function(item2){
							printOeoreID.push(item2.ID);
							oeoreID.push(item2.ID);
						})
					}else{
						printOeoreID.push(item.ID);
						oeoreID.push(item.ID);
					}
		            oeoreSeqID.push(seqID);
		        });
			 }
        };
        if (episodeID.length === 0) {
            $.messager.popover({msg:'δѡ��ҽ��,����ѡ���ҽ���������ӡ������',type:'alert'});
            return false;
        }
	    var getBasicPrintSetting = new Promise(function (resolve) {
	      $m(
	        {
	          ClassName: "Nur.NIS.Service.OrderExcute.SheetPrint",
	          MethodName: "GetBasicPrintSetting",
	          sheetID: sheetId,
	        },
	        function (result) {
	          resolve(result);
	        }
	      );
	    });
        var getPrintForm = new Promise(function (resolve) {
	      $m(
	        {
	          ClassName: "Nur.NIS.Service.OrderExcute.SheetPrint",
	          MethodName: "GetPrintForm",
	          sheetID: sheetId,
	        },
	        function (result) {
	          resolve(result);
	        }
	      );
	    });
        
        var patDataConcurrency = function (chunk) {
      		return new Promise(function (resolve) {
        	$cm(
          		{
            		ClassName: "Nur.NIS.Service.OrderExcute.SheetPrint",
            		MethodName: "GetAllPrintData",
            		parrStr:chunk.join("^"), 
            		sheetID:sheetId, 
            		type:"PAT"
          		},
          		function (result) {
            		resolve(result);
          		}
        		);
      		});
    	};
         var orderDataConcurrency = function (chunk) {
      		return new Promise(function (resolve) {
        	$cm(
          		{
            		ClassName: "Nur.NIS.Service.OrderExcute.SheetPrint",
            		MethodName: "GetAllPrintData",
            		parrStr:chunk.join("^"), 
            		sheetID:sheetId, 
            		type:"ORDER"
          		},
          		function (result) {
            		resolve(result);
          		}
        		);
      		});
    	};   
    	var patChunks = splitChunk(episodeID, 20);    
    	var patPromiseArray = patChunks.map(function(chunk){
	    	return patDataConcurrency(chunk);
	    });
	    var orderChunks = splitChunk(oeoreID, 20);
	    var orderPromiseArray = orderChunks.map(function(chunk){
	    	return orderDataConcurrency(chunk);
	    });
	    Promise.all(patPromiseArray).then(function(patDataRet) {
			Promise.all(orderPromiseArray).then(function(orderDataRet) {
				Promise.all([getBasicPrintSetting,getPrintForm]).then(function(request) {
					console.log(patDataRet);
					console.log(orderDataRet);
					console.log(JSON.parse(request[0]));
					console.log(JSON.parse(request[1]));
					var basicPrintSetting=JSON.parse(request[0]);
					var printForm=JSON.parse(request[1]);
					var patData = {};
					patDataRet.forEach(function(patDataItem) {
						patDataItem.forEach(function(patInfoObj) {
							patInfoObj["printUser"] = printUser;
            				patInfoObj["printRange"] = printRange;
            				patData[patInfoObj["episodeID"]] = patInfoObj;	
						})
					})
					
					var orderPrintData = [];
					orderDataRet.forEach(function(orderDataItem) {
						orderPrintData=orderPrintData.concat(orderDataItem);
					})
					window.SheetPrintOutSide(episodeID.join("^"),oeoreSeqID.join("^"),oeoreID.join("^"),basicPrintSetting,printForm,patData,orderPrintData);
					setExecPrintFlag(unique(printOeoreID),flag);
				})
			})
		})
	} else {
        $.messager.popover({msg:'����ѡ��ҽ����',type:'alert'});
    }
}
function unique(arr) {
    var array = [];
    for (var i = 0; i < arr.length; i++) {
      if (array.indexOf(arr[i]) === -1) {
        array.push(arr[i]);
      }
    }
    return array;
}
function setExecPrintFlag(oeoreID,flag) {
	var savePrintFlagPromises = [];
	var splitChunks=splitChunk(oeoreID,20);
	var setPrintFlagConcurrency = function (chunk) {
      	return new Promise(function (resolve) {
        $m({
	    	ClassName: "Nur.NIS.Service.Base.OrderHandle",
	    	MethodName: "setExecPrintFlag",
	    	oeoreIdStr: chunk.join("^") , 
	    	userId:session["LOGON.USERID"] , 
	    	queryTypeCode: GV.tabCode , 
	    	flag: flag
	    },function(result) {
            resolve(result);
          	});
      	});
    };
	splitChunks.forEach(function(item) {
		savePrintFlagPromises.push(setPrintFlagConcurrency(item))
	});
	Promise.all(savePrintFlagPromises).then(function(request) {
		var result = request.every(function(val) {
        	return String(val) === "0";
      	});
      	if (result) {
	      	$.messager.popover({msg:'��ӡ�ɹ���',type:'success'});
	    }else{
			$.messager.popover({msg:'��ӡʧ�ܣ�',type:'alert'});
		}
		getOrders();
	});
}
// ��ȡȫѡ���ѡ�Ľڵ�
function getAllAndHalfCheckedNodes() {
    var halfNodes=treegridObj.getCheckedNodes('indeterminate')
    var checkedNodes=treegridObj.getCheckedNodes('checked')
    for (var i = 0; i < checkedNodes.length; i++) {
        for (var j = 0; j < halfNodes.length; j++) {
            if (checkedNodes[i]._parentId==halfNodes[j].rowKey) {
                var nodes=halfNodes.splice(j,1)
                checkedNodes.splice(i,0,nodes[0])
                i++;
                break;
            }
        }
    }
    return checkedNodes;
}
// ��ӡ��������
function lisBarPrint(sheetId,flag) {
//	console.log("print");
	// ��ӡ����ҽ����Ŀ
    var filterByArcimItem = prtConfig["ZXD"] ? prtConfig["ZXD"]["ARCIM"] ? "^" + prtConfig["ZXD"]["ARCIM"] + "^" : "" : "";
    // ��ӡ�����÷�
    var filterByOhcinDesc = prtConfig["ZXD"] ? prtConfig["ZXD"]["Instr"] ? "^" + prtConfig["ZXD"]["Instr"] + "^" : "" : "";
    // ����ҽ�����������ӡ����Ҫ��ִ��ʱ��
    var filteOrderStt = prtConfig["filteOrderStt"] === "Y" ? true : false;
    // ����ҽ��ҽ��ִ�к��ֹ��ӡ
    var filteOrderSate = prtConfig["filteOrderSate"] === "Y" ? true : false;
    // ����ҽ��ҽ��ִ�к��ֹ��ӡ-������Ŀ
    var filteOrderSateException = prtConfig["filteOrderSateException"] != "" ? "^" +prtConfig["filteOrderSateException"] + "^" :"";
	var checkedNodes=getAllAndHalfCheckedNodes(),len=checkedNodes.length;
	var curDateTime = new Date();
	if (len) {
		var printRange=$('#appStartDate').datebox('getValue') + "��" + $('#appEndDate').datebox('getValue');
		var printUser=session["LOGON.USERNAME"];
		var oeoreIDList=[],labNoList=[],printOeoreID=[];
		console.log(checkedNodes)
		
		for (var i = 0; i < len; i++) {
	        
            if (checkedNodes[i].execInfos) {
                
                checkedNodes[i].execInfos.forEach(function(item){
                    if (!filterByOrdProperty(checkedNodes[i], "cmArcim", filterByArcimItem) && !filterByOrdProperty(checkedNodes[i], "cmOrdPhcin", filterByOhcinDesc)) {
                        if ((filteOrderSate && (checkedNodes[i].ordStatDesc.indexOf("��ʵ") !==-1  || filteOrderSateException.indexOf("^"+ checkedNodes[i]["cmArcim"] + "^") !== -1 )) || !filteOrderSate) {
	                        if ((filteOrderStt && (curDateTime > new Date(checkedNodes[i].execInfos[0].sttDateTime) )) || !filteOrderStt) {
                            	oeoreIDList.push(item.ID);
                            	labNoList.push(item.labNo);
                            	printOeoreID.push(item.ID);		                    
		                    }
                        }
                    }
                });
                if (checkedNodes[i].sameLabNoOrders && checkedNodes[i].sameLabNoOrders.length >0) {
                    checkedNodes[i].sameLabNoOrders.forEach(function(item){
                        item.execInfos.forEach(function(execItem) {
                            if (!filterByOrdProperty(execItem, "cmArcim", filterByArcimItem) && !filterByOrdProperty(execItem, "cmOrdPhcin", filterByOhcinDesc)) {
                                if ((filteOrderSate && (item.ordStatDesc.indexOf("��ʵ") !==-1  || filteOrderSateException.indexOf("^"+ execItem["cmArcim"] + "^") !== -1 )) || !filteOrderSate) {
                                    oeoreIDList.push(execItem.ID);
                                    printOeoreID.push(execItem.ID);
                                    labNoList.push(execItem.labNo);
                                }
                            }
                        })
                    });
                }
            }
        };
        if (labNoList.length === 0) {
            $.messager.popover({msg:'δѡ��ҽ��,����ѡ���ҽ���������ӡ������',type:'alert'});
            return false;           
        }
        var obj = {};
        for (var j = 0; j < labNoList.length; j++) {
          var singleLabNo = labNoList[j];
          if (obj[singleLabNo]) {
            obj[singleLabNo] = obj[singleLabNo] + "^" + oeoreIDList[j];
          } else {
            obj[singleLabNo] = oeoreIDList[j];
          }
        }
        oeordIdGroup = [];
        for (var k in obj) {
          if (obj[k] !== "") {
            oeordIdGroup.push(obj[k]);
          }
        }
        console.log(oeordIdGroup);
 
       	$m({
	    	ClassName: "Nur.NIS.Service.OrderExcute.XMLPrint",
	    	MethodName: "GetFormwork",
	    	sheetID: sheetId,
	    },function (formwork) {
			console.log(JSON.parse(formwork))
			$m({
	    		ClassName: "Nur.NIS.Service.OrderExcute.XMLPrint",
	    		MethodName: "GetPrintData",
	    		sheetID:sheetId, 
	    		parr:oeordIdGroup.join("@"), 
	    		type:"para"
	    	},function (paraData) {
				console.log(paraData)
				$m({
		    		ClassName: "Nur.NIS.Service.OrderExcute.XMLPrint",
		    		MethodName: "GetPrintData",
		    		sheetID:sheetId, 
		    		parr:oeordIdGroup.join("@"), 
		    		type:"list"
		    	},function (listData) {
			    	console.log(JSON.parse(formwork))
			    	console.log(paraData)
			    	console.log(listData)
					window.NurPrtCommOutSide(JSON.parse(formwork), paraData, listData);
					setExecPrintFlag(unique(printOeoreID),flag);
		    	});			
	    	});
	    });
	     
	} else {
        $.messager.popover({msg:'����ѡ��ҽ����',type:'alert'});
    }
}

// �����������
function clearPlacerNo() {
    var checkedNodes=treegridObj.getCheckedNodes('checked'),len=checkedNodes.length
    if (len) {
        var m=0,n=0
        for (var i = 0; i < len; i++) {
            if (checkedNodes[i].execInfos) {
                m++;
                $cm({
                    ClassName: 'Nur.NIS.Service.Base.OrderHandle',
                    MethodName: "setPlacerNo",
                    dataType: "text",
                    userId:session["LOGON.USERID"],
                    oeoreId:checkedNodes[i].ID,
                    placerNo:checkedNodes[i].originPlacerNo,
                    clearFlag:'Y'
                }, function (data) {
                    n++;
                    if (0!=data) {
                        var obj={
                            '-303':'ִ�м�¼״̬û�б仯, ���ܸı�',
                            '-304':'ִ�м�¼�Ѿ�ִ��,����ֹͣ',
                            '-302':'ִ�м�¼�Ѿ�ֹͣ,������ִ��',
                            '-305':'ִ�м�¼û��ִ��,����Ҫ����',
                            '-306':'ִ�м�¼����ʧ��',
                            '-307':'ִ�м�¼�仯����ʧ��',
                            '-308':'ִ�м�¼�Ʒѱ仯����ʧ��',
                            '-310':'ִ�м�¼��չ����ʧ��',
                            '-301':'ֹͣҽ��ִ�м�¼ʧ��',
                            '-310':'�Ʒ�״̬��ͬ,���øı�',
                            '-311':'�Ѿ��˷�,����Ҫ�����',
                            '-313':'�Ѿ����Ʒ�,����Ҫȡ�����',
                            '-314':'��ʱҽ��δֹͣ���߳���,����ִֹͣ��',
                            '-315':'�޸�ִ�м�¼ҽ��״̬ʧ��',
                            '-316':'�����ϻ�������ʱҽ����ִ�м�¼,������ִ��',
                            '-317':'����ҽ��ֹͣʱ����ִ�м�¼��������ִ��',
                            '-318':'�Ѿ���ҩ������ִֹͣ��(�����ż���)'
                        }
                        $.messager.popover({msg:obj[data]||data,type:'alert'});
                    }else{
                        $.messager.popover({msg:"������������ɹ���",type:'success'});
                    }
                    
                })
            }
        }
        var timer3 = setInterval(function(){
            if(m==n) {
                clearInterval(timer3);
                getOrders();
            }
        },200);
    } else {
        $.messager.popover({msg:'����ѡ��ҽ����',type:'alert'});
    }
}
// ������
function setPlacerNo(e,obj) {
    if (13==e.keyCode) {
	    if (!checkBookAppStatus()) return false;
        var labno=$(obj).data('labno'),placerNo=$(obj).val();
        if (''===placerNo) {
            $.messager.popover({msg:'����Ų���Ϊ�գ�',type:'alert'});
            return;
        }
        if (labno==placerNo) {
            $.messager.popover({msg:'����źͱ걾�Ų�����ȣ�',type:'alert'});
            return;
        }
        if (GV.barcodeLengthConfig&&(GV.barcodeLengthConfig!=placerNo.toString().length)) {
            $.messager.popover({msg:'����λ�����ԣ�Ӧ��Ϊ'+GV.barcodeLengthConfig,type:'alert'});
            return;
        }
        /*var balance=$cm({
            ClassName: 'Nur.NIS.Service.Base.Patient',
            MethodName: "GetBalance",
            EpisodeID: GV.episodeID
        }, false);
        if (balance<0) {
            $.messager.popover({msg:'���ò��㣬����ִ�У�', type:'alert'});
            return;
        }*/
        var childId=''
	    GV.orders.map(function(e1) {
	        if ($(obj).data('id')==e1.ID) {
	            childId=e1.execInfos[0].ID
	        }
	    })
        var data=$cm({
            ClassName: 'Nur.NIS.Service.Base.OrderHandle',
            MethodName: "CheckArrearsBeforeSetPlacerNo",
            execID: childId,
            locID:session['LOGON.CTLOCID'],
            dataType: "text"
        }, false);
        if (data!="") {
            $.messager.popover({msg:data, type:'alert'});
            return;
        }
        
        $cm({
            ClassName: 'Nur.NIS.Service.Base.OrderHandle',
            MethodName: "setPlacerNo",
            dataType: "text",
            userId:session["LOGON.USERID"],
            oeoreId:$(obj).data('id'),
            placerNo:placerNo,
            clearFlag:'N'
        }, function (data) {
            if (0==data) {
                $.messager.popover({msg:'����ű���ɹ�',type:'success'});
                updateSpacer($(obj).data('id'));
            } else {
                $.messager.popover({msg:data,type:'alert'});
            }
            
        })
    }
}
// �òɼ�ʱ��
function updateSpacer(id) {
    var childId=''
    GV.orders.map(function(e) {
        if (id==e.ID) {
            childId=e.execInfos[0].ID
        }
    })
    $cm({
        ClassName: 'Nur.NIS.Service.Base.OrderHandle',
        MethodName: "updateSpacer",
        orderExecIDString:childId,
        userID:session["LOGON.USERID"],
        userDeptId:session["LOGON.CTLOCID"],
        queryTypeCode:GV.tabCode
    }, function (data) {
        if (0==data) {
            getOrders();
        } else {
            // $.messager.popover({msg:data.msg,type:'alert'});
        }
    })
}
// ��ȡ���ݶ�Ӧ��ҽ����Ϣ
function getOrders() {
    var startDate=$('#appStartDate').datebox('getValue')
    if (!startDate || !GV.episodeID) {
        getSheetButtons()
        return;
    }
    $cm({
        // ClassName: 'Nur.NIS.Service.OrderExcute.Execute',
        ClassName: 'Nur.NIS.Service.OrderExcute.QueryOrder',
        MethodName: "GetOrders",
        episodeIDStr:GV.episodeID,
        currentSheetCode:GV.tabCode,
        groupID:session["LOGON.GROUPID"],
        startDate:startDate,
        startTime:'00:00',
        endDate:$('#appEndDate').datebox('getValue'),
        endTime:'23:59',
        hospID:session["LOGON.HOSPID"],
        wardID:session["LOGON.WARDID"],
        locID:session["LOGON.CTLOCID"],
        doctorOrderFlag:true,
        createOrderFlag:false,
        excutedOrderFlag:$HUI.checkbox('#excuteCheck').getValue(),
        orderType:'A',
        ifPrint:$HUI.checkbox('#printCheck').getValue()?true:"",
        longOrderFlag:false,
        tempOrderFlag:false
    }, function (data) {
        $('#keyword').searchbox('setValue','');
        var keys=Object.keys(data)
        // ҳǩ��ɫ���ű�ʶ
        var tab=$('.tabs-container.tabs-gray .tabs-header ul')
        GV.tabData.map(function(elem,index) {
            if (keys.indexOf(elem.code)>-1) {
                tab.children('li:eq('+(index+1)+')').addClass('active')
            } else {
                tab.children('li:eq('+(index+1)+')').removeClass('active')
            }
        });
        data.orders=data.orders||[]
        if (!data.orders.length) {
            $.messager.popover({msg:'����Ϊ�ա�',type:'alert'});
        }
        GV.originalOrder=[];
        $.extend(true,GV.originalOrder,data.orders);
        data.orders=retSetDataOrders(data.orders);
        
        GV.orders=JSON.parse(JSON.stringify(data.orders))
        treegridObj.loadData({rows:data.orders})
        getSheetButtons()
    });
    $("#selectAll").checkbox('setValue',false);
}
function retSetDataOrders(gridData){
	var data={};
	data.orders=gridData;
	for (var index = 0; index < data.orders.length; index++) {
        var elem=data.orders[index];
        if (!regNoLength&&elem.regNo) regNoLength=elem.regNo.trim().length;
        if (elem.EncryptLevel) { //���ò����ܼ�
            data.orders[index].EncryptLevel=GV.patEncrypt[elem.EncryptLevel]
        }
        if (elem.regNo) {
	        data.orders[index].regNo=elem.regNo.trim();
        }
        elem.rowKey=Math.random().toString(32).slice(2, 10)
        // �Ӽ����
        if (elem.notifyClinician) {
            elem.notifyClinician="Y"==elem.notifyClinician?"��":"��"
        }
        // �����
        elem.originPlacerNo=elem.placerNo||""
        if ('undefined'!=typeof elem.placerNo) {
            elem.placerNo='<input data-id="'+elem.ID+'" data-labno="'+elem.labNo+'" value="'+elem.placerNo+'" onkeypress="setPlacerNo(event,this);" class="textbox" style="width: 100%;">'
        } else {
            elem.placerNo='<input data-id="'+elem.ID+'" data-labno="'+elem.labNo+'" value="" onkeypress="setPlacerNo(event,this);" class="textbox" style="width: 100%;">'
        }
        var len=elem.execInfos&&elem.execInfos.length||0
        //����ִ��ʱ��/Ҫ��ִ��ʱ��/ִ����/��Ѫʱ����ʾ����
        if (len ==1){
            elem["sttDateTime"]=elem.execInfos[0]["sttDateTime"]||"";
            elem["execDateTime"]=elem.execInfos[0]["execDateTime"]||"";
            elem["execCtcpDesc"]=elem.execInfos[0]["execCtcpDesc"]||"";
            elem["specCollDateTime"]=elem.execInfos[0]["specCollDateTime"] || "";
            if (elem.execInfos[0]["printFlag"]){
	            elem["arcimDesc"] += '<span class="printFlag">'+(elem.execInfos[0]["printFlag"]||'')+'</span>'
	        }
        }
        var str=''
        if (len) {
            elem.execInfos.map(function(e,i) {
                var partDesc=e.examInfo?e.examInfo.partDesc:"";
                if (!partDesc) partDesc="";
                var partRemark=e.examInfo?e.examInfo.partRemark:"";
                if (!partRemark) partRemark="";
                var TarDesc=e.examInfo?e.examInfo.TarDesc:"";
                if (!partRemark) TarDesc="";
                if (TarDesc) {
                    if (partDesc) {
                        partDesc=partDesc+"��"+TarDesc;
                    }else{
                        partDesc=TarDesc;
                    }
                }
                
                var orderObj={
                    ID:e.ID,
                    bedCode:'',
                    rowKey:Math.random().toString(32).slice(2, 10),
                    arcimDesc:e.sttDate+' '+e.sttTime, //+'<span class="orderTimeChart_examName">'+partDesc+'</span>'+'<span class="printFlag">'+(e.printFlag||'')+'</span>',
                    printFlag:e.printFlag||'',
                    parentArcimDesc:elem.arcimDesc,
                    _parentId:elem.rowKey,
                    ordExecCA:e.ordExecCA||"",
                    labOrdExecNeedPrintedFlag:elem.labOrdExecNeedPrintedFlag||""
                }
                if (len > 1){
                    orderObj["sttDateTime"]=e["sttDateTime"]||"";
		            orderObj["execDateTime"]=e["execDateTime"]||"";
		            orderObj["execCtcpDesc"]=e["execCtcpDesc"]||"";
		            orderObj["specCollDateTime"]=e["specCollDateTime"] || "";
                }
                if (elem.sameLabNoOrders&&elem.sameLabNoOrders.length) {
                    elem.sameLabNoOrders.map(function(e1) {
                        e1.execInfos.map(function(eInfo) {
                            orderObj.ID+='^'+eInfo.ID
                        })
                    })
                }
                if (e.samePartExecInfos&&e.samePartExecInfos.length) {
                    e.samePartExecInfos.map(function(e2) {
                        orderObj.ID+='^'+e2.ID;
                        if (!$.isEmptyObject(e2.examInfo)) {
	                         if ((e2.examInfo.TarDesc)&&(partDesc.indexOf(e2.examInfo.TarDesc)<0)){
		                         partDesc=partDesc+"��"+e2.examInfo.TarDesc;
		                     }
	                    }
                    })
                }
                if (e.childs&&e.childs.length) {
	                e.childs.map(function(childId) {
                        orderObj.ID+='^'+childId;
                    })
	            }
                if (partRemark!="") partDesc=partDesc+" "+partRemark;
                orderObj.arcimDesc=orderObj.arcimDesc+'<span class="orderTimeChart_examName">'+partDesc+'</span>'+'<span class="printFlag">'+(e.printFlag||'')+'</span>';
                data.orders.splice(index+i+1,0,orderObj)
            });
            elem.handleState='<a href="#" class="orderDisposeStatInfo__disposeStat cursorPoint is-label is-'+elem.execInfos[0].disposeStatCode+'">&nbsp;&nbsp;'+disposeStateSets[elem.execInfos[0].disposeStatCode]+'<span class="orderDisposeStatInfo__triangle is-'+elem.execInfos[0].disposeStatCode+'"><span class="orderDisposeStatInfo__circle"></span></span><span class="orderDisposeStatInfo__num">'+len+'</span></a>'+str;
        }
        index=index+len
        len=elem.childs&&elem.childs.length
        str=''
        if (len) {
            elem.childs.map(function(e,i) {
                if (e.orcatDesc&&(e.orcatDesc.indexOf("��ҩ")<0)) {
                    str+='<i class="orderGroupChar__groupChart"></i>'
                    // elem.arcimDesc+='<br>'+e.arcimDesc
                    //orderObj.ID+='^'+e.ID;
                    GV.columns.map(function(e1) {
                        if (JSON.parse(e1.multiply)) {
	                        var len=e.execInfos&&e.execInfos.length||0;
		                    if (len){
			                    e["sttDateTime"]=e.execInfos[0]["sttDateTime"]||"";
					            e["execDateTime"]=e.execInfos[0]["execDateTime"]||"";
					            e["execCtcpDesc"]=e.execInfos[0]["execCtcpDesc"]||"";
					            e["specCollDateTime"]=e.execInfos[0]["specCollDateTime"] || "";
			                }
			                if (e[e1.key]==undefined) e[e1.key]=""
			                if (elem[e1.key]!=undefined) {
				                elem[e1.key]+='<br>'+e[e1.key];
				            }else{
					            elem[e1.key]='<br>'+e[e1.key];
					        }
                        }
                    })
                }
            });
        }
        if (elem.sameLabNoOrders&&elem.sameLabNoOrders.length) {
            elem.sameLabNoOrders.map(function(e) {
                str+='<i class="orderGroupChar__groupChart"></i>'
                // elem.arcimDesc+='<br>'+e.arcimDesc
                GV.columns.map(function(e1) {
                    if (JSON.parse(e1.multiply)) {
	                    var len=e.execInfos&&e.execInfos.length||0;
	                    if (len){
		                    e["sttDateTime"]=e.execInfos[0]["sttDateTime"]||"";
				            e["execDateTime"]=e.execInfos[0]["execDateTime"]||"";
				            e["execCtcpDesc"]=e.execInfos[0]["execCtcpDesc"]||"";
				            e["specCollDateTime"]=e.execInfos[0]["specCollDateTime"] || "";
		                }
		                if (e[e1.key]==undefined) e[e1.key]=""
		                if (elem[e1.key]!=undefined) {
			                elem[e1.key]+='<br>'+e[e1.key];
			            }else{
				            elem[e1.key]='<br>'+e[e1.key];
				        }
	                    
                    }
                })
            })
        }
        for (var key in GV.mutiplyColumns){
            elem["bunch-"+key]=str;
            if ((elem[key])&&(!elem[key].toString().replace(/<br>/g, ""))){
	            elem["bunch-"+key]="";
	        }
        }
        //elem.bunch=str;
    };
    return data.orders;
}
/*-----------------------------------------------------------*/
/**
 * @description Ԫ�ذ��¼�
 */
function initEvent() {
    $('#readCardBtn').click(readCardBtnClick); 
    $("#BBookFind").click(function(){
        $("#appPatGrid").datagrid("load");
    });
    // ���ɸѡ ģ������
    $('#fuzzyKeyword').searchbox({ searcher: function(val) {
        fuzzyKeyword=val;
        fuzzyFilterOrder()
    } });
    // ���ɸѡ ��ȷ����
    $('#keyword').searchbox({ searcher: function(val) {
        keyword=val;
        toggleAndFilterOrder()
    } });
    // �ǼǺŻس���ѯ
    $('#regNO').keypress(function(e) {
        if (13==e.keyCode) {
            var value=$('#regNO').val();
            if (value) {
                while(value.length<10) {
                    value="0"+value
                }
            }
            $(this).val(value);
            $("#appPatGrid").datagrid("load");
        }
    });
    $('#PatName').keypress(function(e) {
        if (13==e.keyCode) {
            $("#appPatGrid").datagrid("load");
        }
    });
}
// ��ȡ���ݶ�Ӧ�İ�ť��Ϣ
function fuzzyFilterOrder() {
    var keywordFilterOrder=[],rowKeys=[],tmpOrders=JSON.parse(JSON.stringify(GV.orders))
    // ���ùؼ��ֹ���
    if (''===fuzzyKeyword || 'undefined'==typeof fuzzyKeyword) {
        keywordFilterOrder=tmpOrders
    } else {
        fuzzyKeyword=fuzzyKeyword.toLowerCase();
        tmpOrders.map(function(elem,index) {
            delete elem.children
            for (var i = 0; i < columnKeys.length; i++) {
                var code=columnKeys[i]
                var text=elem[code]?elem[code].toString().toLowerCase():'';
                var pyjp =getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
                if ((text.indexOf(fuzzyKeyword)>-1)||(pyjp.indexOf(fuzzyKeyword)>-1)) {
                    keywordFilterOrder.push(elem)
                    if (elem.execInfos) { //��ҽ��
                        rowKeys.push(elem.ID) //rowKey
                    }
                    break;
                }
            }
            if (rowKeys.indexOf(elem._parentId)>-1) { //��Ԫ��
                keywordFilterOrder.push(elem)
            }
        });
    }
    rowKeys=[]
    // �ٽ��д�ӡ��ʶ����
    var filterOrder=[],ids=[]

    // (ȥ)ѡ�в��ҹ��˶���
    if (true===curCheckFlag) {
        keywordFilterOrder.map(function(e) {
            if (e.execInfos) { //��ҽ��
                delete e.children
                var flag=false
                e.execInfos.map(function(e2) {
                    if (e2.printFlag.indexOf(curPrintFlag)<0) {
                        flag=true;
                        ids.push(e2.ID)
                    }
                });
                if (flag) {
                    filterOrder.push(e);
                    rowKeys.push(e.ID); //rowKey
                }
            }
            if (ids.indexOf(e.ID)>-1) { //��ҽ��
                filterOrder.push(e);
            }
        });
        filterOrder=retSetDataOrders(filterOrder);
        treegridObj.loadData({rows:filterOrder});
        var newRowKeys=[];
        rowKeys.map(function(id) {
	        var index=$.hisui.indexOfArray(filterOrder,"ID",id);
	        if (index>=0){
		        newRowKeys.push(filterOrder[index].rowKey);
		    }
        });
        newRowKeys.map(function(e) {
            treegridObj.checkNode(e)
        });
    } else {
        keywordFilterOrder.map(function(e) {
            if (e.execInfos) {
                delete e.children
                var flag=false
                e.execInfos.map(function(e2) {
                    if (!e2.printFlag||!e2.printFlag.includes(curPrintFlag)) {
                        flag=true;
                        ids.push(e2.ID)
                    }
                });
                if (flag) {
                    rowKeys.push(e.ID); //rowKey
                }
            }
        });
        treegridObj.loadData({rows:keywordFilterOrder})
        if (false===curCheckFlag) {
	        var newRowKeys=[];
	        rowKeys.map(function(id) {
		        var index=$.hisui.indexOfArray(keywordFilterOrder,"ID",id);
		        if (index>=0){
			        newRowKeys.push(filterOrder[index].rowKey);
			    }
	        });
            newRowKeys.map(function(e) {
                treegridObj.uncheckNode(e)
            });
        }
    }
}
// ��ȡ���ݶ�Ӧ�İ�ť��Ϣ
function toggleAndFilterOrder(printFlag,n) {
    if (printFlag) {
        if (true===curCheckFlag) {
            curCheckFlag=false
            curPrintFlag=""
        } else {
            curCheckFlag=true
            curPrintFlag=printFlag
        }
    }

    var code=$('#titleBox').combobox('getValue');
    // �ǼǺŲ�0
    if ('regNo'==code) {
        while(keyword.length<regNoLength){
            keyword='0'+keyword
        }
        $('#keyword').searchbox('setValue',keyword);
    }
    var flag=false
    var keywordFilterOrder=[],rowKeys=[]; //,tmpOrders=JSON.parse(JSON.stringify(GV.orders))
    var tmpOrders=[];
    $.extend(true,tmpOrders,GV.originalOrder)
    // ���ùؼ��ֹ���
    if (''===keyword || 'undefined'==typeof keyword) {
        keywordFilterOrder=tmpOrders
    } else {
        tmpOrders.map(function(elem,index) {
            delete elem.children
            if (!keyword || keyword==elem[code]) {
                keywordFilterOrder.push(elem)
                if (elem.execInfos) { //��ҽ��
                    rowKeys.push(elem.rowKey)
                }
            }
            if (rowKeys.indexOf(elem._parentId)>-1) { //��Ԫ��
                keywordFilterOrder.push(elem)
            }
        });
    }
    rowKeys=[]
    // �ٽ��д�ӡ��ʶ����
    var filterOrder=[],ids=[]

    // (ȥ)ѡ�в��ҹ��˶���
    if (true===curCheckFlag) {
        keywordFilterOrder.map(function(e) {
            if (e.execInfos) { //��ҽ��
                delete e.children
                var flag=false
                e.execInfos.map(function(e2) {
                    if (e2.printFlag.indexOf(printFlag)<0) {
                        flag=true;
                        ids.push(e2.ID)
                    }
                });
                if (flag) {
                    filterOrder.push(e);
                    rowKeys.push(e.ID); //rowKey
                }
            }
            if (ids.indexOf(e.ID)>-1) { //��ҽ�� 
                filterOrder.push(e);
                // rowKeys.push(e.rowKey);
            }
        });
        filterOrder=retSetDataOrders(filterOrder);
        treegridObj.loadData({rows:filterOrder});
        var newRowKeys=[];
        rowKeys.map(function(id) {
	        var index=$.hisui.indexOfArray(filterOrder,"ID",id);
	        if (index>=0){
		        newRowKeys.push(filterOrder[index].rowKey);
		    }
        });
        newRowKeys.map(function(e) {
            treegridObj.checkNode(e)
        });
    } else {
        keywordFilterOrder.map(function(e) {
            if (e.execInfos) {
                delete e.children
                var flag=false
                e.execInfos.map(function(e2) {
                    if (!e2.printFlag||!e2.printFlag.includes(printFlag)) {
                        flag=true;
                        ids.push(e2.ID)
                    }
                });
                if (flag) {
                    rowKeys.push(e.ID); //rowKey
                }
            }
        });
        keywordFilterOrder=retSetDataOrders(keywordFilterOrder);
        treegridObj.loadData({rows:keywordFilterOrder})
        if (false===curCheckFlag) {
	        var newRowKeys=[];
	        rowKeys.map(function(id) {
		        var index=$.hisui.indexOfArray(filterOrder,"ID",id);
		        if (index>=0){
			        newRowKeys.push(filterOrder[index].rowKey);
			    }
	        });
	        newRowKeys.map(function(e) {
	            treegridObj.uncheckNode(e)
	        });
        }
    }
}
function appPatGridClickRow(rowIndex, rowData) {
    //if ((session["LOGON.CTLOCDESC"]==rowData.appWard)||(session["LOGON.CTLOCDESC"].includes("ԤסԺ"))) {
        curPrintFlag='';
        GV.episodeID=rowData.episodeIDTo;
        if (SwitchSysPat !="N"){
//	        var frm = parent.document.forms["fEPRMENU"];
//	        if (frm) {
//	            frm.EpisodeID.value = rowData.episodeIDTo;
//	            frm.PatientID.value = rowData.patientId;
//	            frm.canGiveBirth.value = rowData.sex === "Ů" ? "1" : "0";
//	        }
        }
        getOrders();
    /*} else {
        $.messager.popover({msg:'����'+rowData.name+'�����ڱ����ң�',type:'error'});
        return;
    }*/
}
function readCardBtnClick() {
    function setCardNo(myrtn) {
	    var myary=myrtn.split("^");
		var rtn=myary[0];
		switch (rtn){
			case "0": 
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
	    		$("#regNO").val(PatientNo);
	    		$("#appPatGrid").datagrid("load");
				break;
			case "-200": 
				$.messager.alert("��ʾ","����Ч!","info",function(){
					$("#regNO").val("");
				});
				break;
			case "-201": 
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
	    		$("#regNO").val(PatientNo);
	    		$("#appPatGrid").datagrid("load");
				break;
			default:
				break;
		}
    }
    DHCACC_GetAccInfo7(setCardNo);
}
function myformatter(date){
    var y = date.getFullYear();
    var m = date.getMonth()+1;
    var d = date.getDate();
    if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
    else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
    else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
        var ss = s.split('/');
        var y = parseInt(ss[2],10);
        var m = parseInt(ss[1],10);
        var d = parseInt(ss[0],10);
    }else{
        var ss = s.split('-');
        var y = parseInt(ss[0],10);
        var m = parseInt(ss[1],10);
        var d = parseInt(ss[2],10);
    }
    if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
        return new Date(y,m-1,d);
    } else {
        return new Date();
    }
}
function InitAppPatGrid(){
    var Columns=[[
        { field: 'sex', title: '�Ա�',width:60},
        { field: 'age', title: '����',width:60},
        { field: 'tel', title: '��ϵ�绰',width:110},
        { field: 'bookNo', title: 'סԺ֤��',width:120},
        { field: 'bookStatus', title: '״̬',width:80},
        { field: 'bookLoc', title: 'ԤԼ����',width:120},
        { field: 'appWard', title: 'ԤԼ����',width:120},
        { field: 'appDate', title: 'ԤԼʱ��',width:110},
        { field: 'bookdoc', title: 'ԤԼҽ��',width:100},
        { field: 'bookCreateUser', title: '��֤ҽ��',width:100},
        { field: 'operName', title: '�ռ�����',width:120},
        { field: 'operDate', title: '��������',width:100}        
    ]];
    $('#appPatGrid').datagrid({  
        fit : true,
        width : 'auto',
        border : false,
        striped : true,
        singleSelect : true,
        fitColumns : false,
        autoRowHeight : false,
        loadMsg : '������..',  
        pagination : true, 
        rownumbers : false,
        idField:"bookID",
        pageSize: 15,
        pageList : [15,50,100,200],
        columns :Columns,
        autoSizeColumn:false,
        nowrap:false,  /*�˴�Ϊfalse*/
        frozenColumns:[[
            { field: 'patRegNo', title: '�ǼǺ�',width:100}, 
            { field: 'name', title: '����',width:100}
        ]],
        url : $URL+"?ClassName=Nur.InService.AppointPatOrder&QueryName=findBookPat",
        onBeforeLoad:function(param){
            $('#appPatGrid').datagrid("unselectAll");
            if (treegridObj){
            	treegridObj.loadData({rows:[]});
            }
            param = $.extend(param,{
                BookNo:$("#BookNo").val(),
                RegNo:$("#regNO").val(),
                StartDate:$("#appStartDate").datebox("getValue"),
                EndDate:$("#appEndDate").datebox("getValue"),
                PatName:$("#PatName").val(),
                // PatName:"2503",
                BookLoc:$("#appLocBox").combobox("getValue"),
                BookWard:$("#appWardBox").combobox("getValue"),
                BookDoctor:$("#bookDocBox").combobox("getValue"),
                BookStatus:"P",
                ExcludeStatus:"����",
                DaySurgeryLocLinkStr:IsDaySurgeryLoc=="Y"?GetDaySurgeryLocLinkStr():""
            });
        },
        onClickRow:function(rowIndex, rowData){
	        if ((!(typeof window.parent.SetChildPatNo == "function"))&&(!(typeof window.parent.ChangePerson === "function"))) {
				var frm=dhcsys_getmenuform();
				var menuWin=websys_getMenuWin();
				if ((menuWin) &&(menuWin.MainClearEpisodeDetails)) menuWin.MainClearEpisodeDetails();
				if (frm){
					frm.EpisodeID.value=rowData["episodeIDTo"];
					frm.PatientID.value=rowData["patientId"];
					frm.mradm.value="";
					if (frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
					if (frm.canGiveBirth) frm.canGiveBirth.value = "";
					if (frm.PPRowId) frm.PPRowId.value = "";
				}
			}
            appPatGridClickRow(rowIndex, rowData);
        }
    })
}
if (!Array.prototype.includes) {
    Array.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
if (!String.prototype.includes) {
    String.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
function GetDaySurgeryLocLinkStr(){
	var DaySurgeryLocLinkStr="";
	var data=$("#appWardBox").combobox("getData")
	for (var i=0;i<data.length;i++){
		if (DaySurgeryLocLinkStr=="") DaySurgeryLocLinkStr=data[i].ID;
		else DaySurgeryLocLinkStr=DaySurgeryLocLinkStr+"^"+data[i].ID;
	}
	return DaySurgeryLocLinkStr;
}
