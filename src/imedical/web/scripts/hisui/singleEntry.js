/**
 * @author wujiang 
 * @description 单人录入界面 20200222
 */
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
if(!Array.from){
    Array.from = function (el) {
        return Array.apply(this, el);
    }
} 
var GV = {
    tabCode:'',
    columns:'',
    episodeID:'',
    visitTime:'',//就诊时间
    dateformat:'',//时间格式
    orders:[],
    ClassName: "Nur.InService.AppointPatManage"
}
var babyCode= {
      // 使用老版维护界面维护得项目不对， 成人和婴儿不同的项目描述维护的code一样了，我们新版处理不了同一个项目code不同的描述
      // 婴儿时，flag为空，替换对应的code为该item的描述
      Item9: "小便",
      Item10: "脐部情况",
      Item11: "大便(色)",
      Item14: "大便(次)",
      Item18: "脐带",
      Item23: "皮肤"
    }
var ifBaby=0;//1婴儿，0成人
var curLogDate;//当前记录日期
var timeArr= ["02:00", "06:00", "10:00", "14:00", "18:00", "22:00"]
/*-----------------------------------------------------------*/
var init = function () {
    // console.log('---------window---------');
    // console.log(window);
    // console.log('---------window.session---------');
    // console.log(window.session);
    // console.log('---------$HUI---------');
    // console.log($HUI);
    initBasicData()
}
$(init)
// enter切换input
document.addEventListener('keyup', function (event) {
    // if (13==event.keyCode||40==event.keyCode) {
    if ([13,38,40].includes(event.keyCode)) {
        var inputs=document.querySelectorAll('#vitalSigns tr input')
        var input=document.querySelector('#vitalSigns tr input:focus')
        inputs=Array.from(inputs)
        var i=inputs.indexOf(input)
        if (i>-1) {
            if (38==event.keyCode) {
                i--;
                if ('combo-value'==inputs[i].className) i--;
            } else {
                i++;
                if ('combo-value'==inputs[i].className) i++;
            }
            inputs[i]&&inputs[i].focus()
        }
        // var ev = new KeyboardEvent('keydown', {
        //     keyCode: 9
        // });
        // document.dispatchEvent(ev);
    }
}, false);
function updatePatientInfo(rowData) {
    // 更新患者信息
    // var frm = dhcsys_getmenuform();
    
    if (rowData["motherADM"]) {
        ifBaby=1;
    } else if (rowData["PAPMIAge"]) {
        if (parseFloat(rowData["PAPMIAge"])<18) {
            ifBaby=1;
        } else {
            ifBaby=0;
        }
    } else {
        ifBaby=0;
    }
    // console.log(rowData["EpisodeID"]);
    GV.episodeID=rowData["EpisodeID"]

    var timer = setInterval(function(){
        if(GV.dateformat) {
            clearInterval(timer);
            if (!rowData["PAAdmDate"]||!rowData["PAAdmTime"]) {
                GV.visitTime='';
                $.messager.popover({msg: '入院时间为空，不可录入体征数据。',type:'alert'});
                setTimeout(function(){
                    var textboxArray=$("#vitalSigns input.textbox")
                    textboxArray.map(function(index,elem) {
                        $(elem).attr({disabled:true}).next('.symbol').addClass('disabled');//禁用;
                    })
                    var comboxArray=$("#vitalSigns .hisui-combobox")
                    comboxArray.map(function(index,elem) {
                        $(elem).combobox({disabled:true});//禁用;
                    })
                },1000);
                // $('#logDate').datebox({disabled:true,setValue: formatDate(new Date())});//禁用;
                // $('#logTime').timespinner('disable');
                return;
            }else{
                // $('#logDate').datebox({disabled:false,setValue: formatDate(new Date())});
                // $('#logTime').timespinner('enable');
            }
            var yPos=GV.dateformat.indexOf('YYYY')
            var year=rowData["PAAdmDate"].slice(yPos,yPos+4)
            var mPos=GV.dateformat.indexOf('MM')
            var month=rowData["PAAdmDate"].slice(mPos,mPos+2)
            var dPos=GV.dateformat.indexOf('DD')
            var day=rowData["PAAdmDate"].slice(dPos,dPos+2)
            GV.visitTime=year+'-'+month+'-'+day+' '+rowData["PAAdmTime"].slice(0,5)
            console.log(GV.visitTime);
        }
    },100);
    // findTempDataByDay()
    getSystemSetting()
    initBasicData()
}
// 获取系统配置
function getSystemSetting() {
    // 获取SingleConfig
    $cm({
        ClassName: 'Nur.NIS.Service.System.Config',
        MethodName: "GetSystemConfig"
    }, function (result) {
        GV.dateformat=result.dateformat;
    });
}
// 初始化基础数据
function initBasicData() {
    // 获取SingleConfig
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
        MethodName: "GetAllTempConfig",
        locID:session["LOGON.CTLOCID"],
        time:'',
        wardId:session['LOGON.WARDID']
    }, function (result) {
        // console.log(result);
          if (1 == ifBaby) {
            // 婴儿时，flag为空，替换对应的code为该item的描述
            result.SingleConfig.map(function(elem) {
              if ("" === elem.flag) {
                elem.desc = babyCode[elem.code] || elem.desc;
              }
            });
          }
          GV.configData = result.SingleConfig;
          GV.data = checkAdultOrBaby(
            GV.configData,
            // this.$attrs.patientMsg.ifNewBaby
            ifBaby
          );
          // console.log(JSON.stringify(GV.data));
          for (var j = 0; j < GV.data.length; j++) {
            if ('true'===GV.data[j].blank||true===GV.data[j].blank) {
                // console.log(JSON.stringify(GV.data[j]));
              var blankTrueIndex = j;
              var blankInfo = GV.data.splice(blankTrueIndex, 1)[0];
              for (var i = 0; i < GV.data.length; i++) {
                if (blankInfo.blankTitleCode == GV.data[i].code) {
                    // console.log(JSON.stringify(GV.data[i]));
                  GV.data[i].blankTitleInputTime = blankInfo.blankTitleInputTime;
                  GV.data[i].codeOri = GV.data[i].code;
                  GV.data[i].select = false;
                  GV.data[i].code = blankInfo.code;
                  GV.data[i].times = blankInfo.times;
                  break;
                }
              }
                j--;
            }
          }
          // console.log(JSON.stringify(GV.data));
        // 初始化时间
        curLogDate=new Date();
        $('#logDate').datebox('setValue', formatDate(new Date()));
        $("#logTime").timespinner('setValue', timeArr[Math.floor(new Date().getHours() / 4)]);  //赋值
          findTempDataByDay();
    });
}

// 判断成人婴儿
function checkAdultOrBaby(data, flag) {
  // flag //0成人，1婴儿
  return data.filter(function(elem) {
    return flag == elem.flag || "" === elem.flag || 'undefined'==typeof elem.flag;
  });
}
// 获取单个时间点体征数据
function findTempDataByDay(date) {
    console.log(date);
    if (new Date(date).valueOf()) {
        curLogDate=new Date(date);
        console.log(curLogDate.valueOf());
    }
    if (date&&!GV.visitTime) {return;}
    // console.log(111);
    // console.log(GV.episodeID);
    if (!GV.episodeID) {return;}
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
        MethodName: "GetPatientsTempDataByTime",
        episodeIDString:JSON.stringify([GV.episodeID]), 
        date:$("#logDate").datebox('getValue'), 
        time:$("#logTime").timespinner('getValue'),
        LocId:''
    }, function (res) {
        res=res[0]
        var html=''
        // console.log(GV.data);
        GV.data.map(function(elem,index) {
            html+='<tr>'
            if (elem.codeOri) {
                elem.select=true
                html+='<td>'+getShowType(elem,res[elem.codeOri]&&res[elem.codeOri].value)+'</td>'
                elem.select=false
                html+='<td>'+getShowType(elem,res[elem.code]&&res[elem.code].value)+'</td>'
            } else {
                html+='<td>'+elem.desc+'</td>'
                html+='<td>'+getShowType(elem,res[elem.code]&&res[elem.code].value)+'</td>'
            }
            html+='</tr>'
        });
        // console.log(html);

        $('table#vitalSigns').html(html);
        $('table#vitalSigns input.textbox').css({
            width: '130px',
            height: '30px'
        }).blur(checkValueWhenBlur);
        $('table#vitalSigns .hisui-combobox').css('width', '137px').combobox({
            onChange:function(nval,oVal) {
                saveVitalSigns(true);
            }
        });
        $('table#vitalSigns td>.symbol>span').bind('click', function() {
            var html=$(this).html()
            var $input=$(this).parent().prev('input')
            $input.val($input.val()+html)
        });
    })
}
// 获取显示类型，input或者select
function getShowType(obj,val) {
    if ('undefined'==typeof val) {
        val=''
    }
    var html=''
    if ('true'===obj.select || true===obj.select) {
        if (obj.codeOri) {
            html+='<select class="hisui-combobox" placeholder="'+obj.desc+'" value="'+val+'">'
        } else {
            html+='<select class="hisui-combobox" value="'+val+'">'
        }
        html+='<option value=""></option>'
        obj.options.map(function(elem) {
            if (val==elem) {
                html+='<option value="'+elem+'" selected>'+elem+'</option>'
            } else {
                html+='<option value="'+elem+'">'+elem+'</option>'
            }
        });
        html+='</select>'                    
    } else {
        html+='<input value="'+val+'" data-obj=\''+JSON.stringify(obj)+'\' class="textbox">'
        if (obj.symbol&&obj.symbol.length) {
            html+='<div class="symbol">'
            obj.symbol.map(function(elem) {
                html+='<span>'+elem+'</span>'
            });
            html+='</div>'                    
        }
    }
    return html;
}
function checkValueWhenBlur() {
    checkInputValue(true)
}
function checkInputValue(saveFlag) {
    var inputVal
    $('table#vitalSigns').find('tr.error,tr.warning').removeClass('error warning')
    var time=$("#logTime").timespinner('getValue'),data=[],flag=false;
    GV.data.map(function(elem,index) {
        var $tr=$('table#vitalSigns tr:eq('+index+')')
        if (elem.codeOri) {
            data.push({
                code:elem.codeOri,
                value:$tr.find('td:eq(0) input.combo-value').val(),
                time:time
            })
            $inputVal=$tr.find('td:eq(1)>input').val()            
        } else {
            if ('true'===elem.select || true===elem.select) {
                data.push({
                    code:elem.code,
                    value:$tr.find('td:eq(1) input.combo-value').val(),
                    time:time
                })
                return;
            } else {
                $inputVal=$tr.find('td:eq(1)>input').val()
            }
        }
        if (('true'===elem.validate || true===elem.validate)&&$inputVal) {
            var symbol = elem.symbol;
            if (!symbol || !symbol.includes($inputVal)) {
                // 有范围约束的必须是数字
                if (elem.normalValueRangTo||elem.errorValueHightFrom||elem.errorValueLowTo||elem.normalValueRangFrom) {
                  if ($inputVal!=parseFloat($inputVal)) {
                    flag=true;
                    $tr.addClass('error')
                    // $.messager.popover({msg: elem.desc+'的值是数字类型。',type:'error'});
                    return "error";
                  }
                }
                // 当有error范围值的时候进行error校验
                if ((elem.errorValueHightFrom)&&(parseFloat($inputVal) > parseFloat(elem.errorValueHightFrom))) {
                  flag=true;
                  $tr.addClass('error')
                  // $.messager.popover({msg: elem.desc+'的值不能大于'+elem.errorValueHightFrom,type:'error'});
                  return ;
                }
                if ((elem.errorValueLowTo)&&(parseFloat($inputVal) < parseFloat(elem.errorValueLowTo))) {
                  flag=true;
                  $tr.addClass('error')
                  // $.messager.popover({msg: elem.desc+'的值不能小于'+elem.errorValueLowTo,type:'error'});
                  return ;
                }
                // 当有warning范围值的时候进行warning校验
                if (
                  parseFloat($inputVal) < parseFloat(elem.normalValueRangFrom) ||
                  parseFloat($inputVal) > parseFloat(elem.normalValueRangTo)
                ) {
                      $tr.addClass('warning')
                }
            }
        }
        data.push({
            code:elem.code,
            value:$inputVal,
            time:time
        })
    });
    if (saveFlag) {
        saveVitalSigns(true)
    }
    return [flag,data];
}
function saveVitalSigns(noRemindFlag) {
    if (!GV.visitTime) {
        return;
    }
    if (!GV.episodeID) {
        $.messager.popover({msg: '请先选择患者',type:'alert'});
        return;
    }
    var date=$("#logDate").datebox('getValue')
    var time=$("#logTime").timespinner('getValue'),data=[],flag=false
    if (!date || !time) {
        $.messager.popover({msg: '时间不能为空。',type:'alert'});
        return;
    } else {
        var month=(curLogDate.getMonth()+1).toString();
        if (month.length<2) {month="0"+month}
        var day=curLogDate.getDate().toString();
        if (day.length<2) {day="0"+day}
        var dateTime=curLogDate.getFullYear()+'-'+month+'-'+day+' '+time
        var dateTime2=curLogDate.getFullYear()+'-'+month+'-'+day+' 00:00:00'
        if (new Date(dateTime2).valueOf()>new Date().valueOf()) {
            $.messager.popover({msg: '不能录入当天以后的数据。',type:'alert'});
            return;
        }
        // 是否要判断入院日期
        if (config.inHospDateTimeFlag) {
            if (new Date(dateTime).valueOf()<new Date(GV.visitTime).valueOf()) {
                $.messager.popover({msg: '不能录入就诊时间之前的数据。',type:'alert'});
                return;
            }
        }
    }
    var result=checkInputValue()
    flag=result[0]
    data=result[1]
    if (flag) {return;}
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
        MethodName: "SaveObsDataByDay",
        episodeID:GV.episodeID,
        modifyData:JSON.stringify(data),
        userID:session["LOGON.USERID"],
        date:date,
        userLocID:session["LOGON.CTLOCID"],
        wardID:session['LOGON.WARDID']
    }, function (res) {
        if (0==res) {
            if (!noRemindFlag) {
                $.messager.popover({msg: '数据保存成功',type:'success'});
            }
          hrefRefresh();
        } else {
          $.messager.popover({msg: res,type:'alert'});
        }
    });
}

function showModal(pageName){
	if (!GV.episodeID) {
        $.messager.popover({msg: '请先选择患者',type:'alert'});
        return;
    }
    var url='dhc.nurse.vue.nis.csp?1=1'+'&pageName=vitalSign/biz/'+pageName+'&EpisodeID='+GV.episodeID;
    websys_createWindow(url,"newwin","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return;
}