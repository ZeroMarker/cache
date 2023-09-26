/**
 * 手术安排横幅
 * @author yongyang 2018-03-23
 */

(function(global, factory) {
    factory(global.operScheduleBanner = {});
}(this, function(exports) {

    function init(dom, opt) {
        return new OperScheduleBanner(dom, opt);
    }

    exports.init = init;

    function OperScheduleBanner(dom, opt) {
        this.dom = $(dom);
        this.options = $.extend(this.options || {}, opt);
        this.patientCodeOptionView = patientCodeOptionView;
        this.labResultView = labResultView;
        this.retrieveLabResultHandler = opt.retrieveLabResultHandler;
        this.pathResultView = pathResultView;
        this.init();
    }

    OperScheduleBanner.prototype = {
        constructor: OperScheduleBanner,
        /**
         * 初始化
         */
        init: function() {
            var _this = this;
            this.dom.addClass('oper-banner');
            this.patientCodeOptionView.init(function(patientCode) {
                _this.changePaitenCode(patientCode);
            });

            this.labResultView.init({});
            this.dom.delegate('.oper-banner-labresult', 'click', function() {
                _this.labResultView.open();
                _this.retrieveLabResult();
            });

            this.pathResultView.init({});
            this.dom.delegate('.oper-banner-pathresult', 'click', function() {
                _this.pathResultView.open();
                _this.pathResultView.load({opsId:_this.operSchedule.RowId});
            });
        },
        /**
         * 设置参数
         */
        setOptions: function(opt) {
            this.options = $.extend(this.options || {}, opt);
            if (this.operSchedule) this.render();
        },
        /**
         * 加载数据
         */
        loadData: function(data) {
            this.operSchedule = data;
            this.dom.find('.hisui-tooltip').tooltip('destroy');
            this.render();
        },
        /**
         * 渲染
         */
        render: function() {
            var _this = this;
            this.dom.empty();
            var operSchedule = this.operSchedule;
            var avatar = $('<div class="oper-banner-avatar"></div>');
            if (operSchedule.PatGender === '女') {
                avatar.append('<span class="icon-large avatar-female"></span>');
            } else {
                avatar.append('<span class="icon-large avatar-male"></span>');
            }

            var tagContainer = $('<div class="oper-banner-tag-container"></div>');

            var content = $('<div class="oper-banner-content"></div>');

            if(operSchedule.OperStatusCode == "RoomIn"){
                content.addClass("oper-banner-operating");
            }
            else if(operSchedule.OperStatusCode == "RoomOut" || operSchedule.OperStatusCode == "Finish"){
                content.addClass("oper-banner-finished");
            }
            else if(operSchedule.OperStatusCode == "Cancel" || operSchedule.OperStatusCode == "Stop"){
                content.addClass("oper-banner-Stopped");
            }

            var contentArray = [];
            contentArray.push('<span class="oper-banner-patname">' + operSchedule.PatName + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.PatGender + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.PatAge + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info patient-code-container"><span class="patient-code" name="MedcareNo">住院号</span><span>' + operSchedule.MedcareNo + '</span></span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.WardBed + '</span>');
            if (operSchedule.PrevAnaMethodDesc) {
                contentArray.push('<span class="oper-banner-seperator"></span>');
                contentArray.push('<span class="oper-banner-info">' + operSchedule.PrevAnaMethodDesc + '</span>');
            }
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info" style="display:inline-block;max-width:200px;overflow:hidden;text-overflow:ellipsis;" title="' + operSchedule.OperInfo + '">' + operSchedule.OperInfo + '</span>');
            contentArray.push('<span class="oper-banner-seperator"></span>');
            contentArray.push('<span class="oper-banner-info">' + operSchedule.AdmReason + '</span>');


            content.append(contentArray.join(''));

            this.dom.append(avatar);
            this.dom.append(content);
            this.dom.append(tagContainer);

            if (operSchedule.OperStatusCode == "RoomIn") {
                var title = operSchedule.ActualOperTime;
                var timeStr = title.substr(11, 5);
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" style="background-color:#900;color:#fff;border-radius:5px;padding:2 5px;" title="手术开始时间：' + title + '">切皮 ' + timeStr + '</span>');
            }
            if (operSchedule.ABO && operSchedule.ABO !== "") {
                var title = operSchedule.ABO.replace(/#/g, "&#10;");
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" title="' + title + '">' + title + '</span>');
            }
            if (operSchedule.RH && operSchedule.RH !== "") {
                var title = operSchedule.RH.replace(/#/g, "&#10;");
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" title="' + title + '">' + title + '</span>');
            }
            if (operSchedule.SourceType === 'E') {
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" title="急诊">急</span>');
            }
            if (operSchedule.Infection && operSchedule.Infection.indexOf("阳性") >= 0) {
                var title = operSchedule.InfectionLabData.replace(/#/g, "&#10;<br>");
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" title="' + title + '">感</span>');
            }
            if (operSchedule.Antibiotic && parseInt(operSchedule.Antibiotic) > 0) {
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" title="抗生素' + operSchedule.Antibiotic + '支">抗</span>');
            }
            if (operSchedule.LongOperation === "Y") {
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" title="手术时长超过3小时">超时</span>');
            }
            if (operSchedule.PathResult && operSchedule.PathResult !== "") {
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip oper-banner-pathresult" data-options="position:\'bottom\'" title="点击查看病理结果">病</span>');
            }
            if (operSchedule.AllergicHistory && operSchedule.AllergicHistory === "有") {
                tagContainer.append('<span class="oper-banner-tag hisui-tooltip" data-options="position:\'bottom\'" title="有过敏史">敏</span>');
            }

            //$('<span class="oper-banner-tag hisui-tooltip oper-banner-labresult" data-options="position:\'bottom\'" title="点击查看历次检验结果">检</span>').appendTo(tagContainer);

            this.dom.find('.hisui-tooltip').tooltip({});

            this.patientCodeContainer = this.dom.find('.patient-code-container');

            this.dom.delegate('.patient-code', 'mouseenter', function() {
                _this.patientCodeOptionView.position($(this).offset());
                _this.patientCodeOptionView.open();
            })
        },
        /**
         * 改变病人编码显示
         */
        changePaitenCode: function(patientCode) {
            this.patientCodeContainer.empty()
                .append('<span class="patient-code" name="' + patientCode.field + '">' + patientCode.desc + '</span>')
                .append('<span>' + (this.operSchedule[patientCode.field] || '') + '</span>');
        },
        retrieveLabResult: function() {
            var _this = this;
            if (this.retrieveLabResultHandler && this.operSchedule) {
                this.retrieveLabResultHandler(this.operSchedule.MedcareNo, function(data) {
                    _this.labResultView.render(data);
                })
            }
        }
    }

    /**
     * 病人编码选项选择界面
     */
    var patientCodeOptionView = {
        init: function(callback) {
            var _this = this;
            this.callback = callback;
            this.dom = $('<div class="oper-banner-patientcodeview"></div>').appendTo('body');
            this.dom.delegate('.oper-banner-patientcodeview-i', 'click', function() {
                $(this).siblings().removeClass('patientcodeview-selected');
                $(this).addClass('patientcodeview-selected');
                _this.callback({
                    field: $(this).attr('value'),
                    desc: $(this).text()
                });
                _this.close();
            });

            this.container = $('<div class="oper-banner-patientcodeview-container"></div>').appendTo(this.dom);

            $('<div class="oper-banner-patientcodeview-i patientcodeview-selected" value="MedcareNo">住院号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i" value="RegNo">登记号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i" value="CardNo">卡号</div>').appendTo(this.container);
            $('<div class="oper-banner-patientcodeview-i" value="EpisodeID">就诊号</div>').appendTo(this.container);

            this.close();
            this.dom.mouseleave(function() {
                _this.close();
            });
            this.initiated = true;
        },
        render: function(currentSelection) {

        },
        position: function(position) {
            this.dom.css({ left: position.left - 10, top: position.top + 25 });
        },
        open: function() {
            this.dom.show();
        },
        close: function() {
            this.dom.hide();
        }
    };

    /**
     * 感染结果查看
     */
    var infectiousView = {
        init: function(opt) {
            var _this = this;
            this.loaded = false;
            this.dom = $('<div></div>').appendTo('body');
            this.container = $('<div class="oper-banner-infectiousview-container"></div>').appendTo(this.dom);
            this.dom.dialog({
                left: 400,
                top: 50,
                height: 500,
                width: 620,
                title: '感染结果',
                modal: false,
                closed: true,
                resizable: true,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.close();
            this.dom.mouseleave(function() {
                _this.close();
            });
            this.initiated = true;
        },
        load:function(param){
            var _this=this;
            var opsId=param.opsId;
		    var data=dhccl.getDatas(ANCSP.DataQuery,{
			    ClassName:"DHCAN.BLL.Pathology",
			    QueryName:"FindPathologyRecord",
			    Arg1:opsId,
			    ArgCnt:1		
		    },"json",true,function(data){				
			    if (data && data[0]){
                        _this.loadData(data[0]);
			    }
		    });	
        },
        loadData:function(record){
            if (this.loaded){
                for(var field in record){
                    this.dom.find('.'+field).text(record[field]);
                }
            }
            else{
                this.data=record;
                this.delayLoadData=true;
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            
        }
    }

    /**
     * 病理结果查看
     */
    var pathResultView = {
        init: function(opt) {
            var _this = this;
            this.loaded = false;
            this.dom = $('<div></div>').appendTo('body');
            this.dom.dialog({
                left: 400,
                top: 50,
                height: 500,
                width: 620,
                title: '病理结果',
                modal: false,
                closed: true,
                resizable: true,
                href:'dhcan.pathologyresult.csp',
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                },
                onLoad:function(){
                    _this.loaded=true;
                    if(_this.delayLoadData){
                        _this.loadData(_this.data);
                    }
                }
            });

            this.close();
            this.dom.mouseleave(function() {
                _this.close();
            });
            this.initiated = true;
        },
        load:function(param){
            var _this=this;
            var opsId=param.opsId;
		    var data=dhccl.getDatas(ANCSP.DataQuery,{
			    ClassName:"DHCAN.BLL.Pathology",
			    QueryName:"FindPathologyRecord",
			    Arg1:opsId,
			    ArgCnt:1		
		    },"json",true,function(data){				
			    if (data && data[0]){
                        _this.loadData(data[0]);
			    }
		    });	
        },
        loadData:function(record){
            if (this.loaded){
                for(var field in record){
                    this.dom.find('.'+field).text(record[field]);
                }
            }
            else{
                this.data=record;
                this.delayLoadData=true;
            }
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            
        }
    }

    /**
     * 详细检验结果查看
     */
    var labResultView = {
        init: function(opt) {
            var _this = this;
            this.dom = $('<div></div>').appendTo('body');
            this.container = $('<div class="oper-banner-labresultview-container"></div>').appendTo(this.dom);

            this.dom.dialog({
                left: 500,
                top: 50,
                height: 400,
                width: 500,
                title: '历次检验结果',
                modal: false,
                closed: true,
                resizable: true,
                onOpen: function() {

                },
                onClose: function() {
                    _this.clear();
                }
            });

            this.close();
            this.dom.mouseleave(function() {
                _this.close();
            });
            this.initiated = true;
        },
        render: function(data) {
            this.container.empty();
            var tabs = $('<div class="labresult tabs-gray"></div>').appendTo(this.container);
            tabs.tabs({
                height: 360,
                width: 498,
                tabPosition: 'left',
                nowrap: true,
                headerwidth: 160
            });
            var groups = groupingData(data);

            var length = groups.length;
            var tab = null;
            for (var i = 0; i < length; i++) {
                tab = $('<div></div>');
                tabs.tabs('add', {
                    title: groups[i].text,
                    selected: false,
                    content: tab
                });
                groupview.render(tab, groups[i]);
            }

            tabs.tabs('select', 0);
        },
        open: function() {
            this.dom.dialog('open');
        },
        close: function() {
            this.dom.dialog('close');
        },
        clear: function() {
            this.container.empty();
        }
    }

    function groupingData(data) {
        var groupBy = {
            textField: 'TestClassName',
            key: 'TestClassName',
            exceptedText: '其它'
        };
        var groups = {};
        var dataGroups = [];
        var excepted = [];

        var length = data.length;
        for (var i = 0; i < length; i++) {
            var row = data[i];
            var groupIndexText = row[groupBy.textField];
            if (groupIndexText) {
                var groupIndex = row[groupBy.key];
                if (!groups[groupIndex]) groups[groupIndex] = [];
                groups[groupIndex].push(row);
            } else {
                excepted.push(row);
            }
        }

        for (var groupIndex in groups) {
            dataGroups.push({
                key: groupIndex,
                text: groups[groupIndex][0][groupBy.textField],
                rows: groups[groupIndex]
            });
        }

        if (excepted.length > 0) {
            dataGroups.push({
                key: '',
                text: groupBy.exceptedText,
                rows: excepted
            })
        }

        return dataGroups;
    }

    var groupview = {
        render: function(container, group) {
            var table = $('<table></table>').appendTo(container);
            var thead = $('<thead></thead>').appendTo(table);
            var trow = $('<tr><th>项目</th><th>结果</th><th>单位</th><th>范围</th></tr>').appendTo(thead);
            var tbody = $('<tbody></tbody>').appendTo(table);

            var length = group.rows.length;
            for (var i = 0; i < length; i++) {
                trow = $('<tr></tr>').appendTo(tbody);
                rowview.render(trow, group.rows[i]);
            }
        }
    }

    var rowview = {
        render: function(container, row) {
            container.data('data', row);
            $('<td></td>').text(row.TestCodeDesc).appendTo(container);
            $('<td></td>').text(row.TestResult).appendTo(container);
            $('<td></td>').text(row.TestResultUnitCode).appendTo(container);
            $('<td></td>').text(row.TestResultRange).appendTo(container);
        }
    }
}));