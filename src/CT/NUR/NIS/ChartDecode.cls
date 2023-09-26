Class CT.NUR.NIS.ChartDecode Extends %Persistent [ SqlTableName = ChartDecode, StorageStrategy = SQLStorage ]
{

Index ChartRowID On ChartDr [ Unique ];

/// Chart Parent Reference
Property ChartDr As Chart [ Required, SqlColumnNumber = 2, SqlFieldName = ChartDr ];

/// LinesJson
Property LinesJson As %Text(MAXLEN = 50000, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LinesJson ];

/// TextJson 
Property TextJson As %Text(MAXLEN = 50000, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TextJson ];

/// TimePoints 
Property TimePoints As %String [ SqlColumnNumber = 5, SqlFieldName = TimePoints ];

/// PageDays 
Property PageDays As %String [ SqlColumnNumber = 6, SqlFieldName = PageDays ];

/// 手术事件指针
Property EventDr As User.MRCObservationItem [ SqlColumnNumber = 7, SqlFieldName = EventDr ];

/// 术次样式
Property OperDayStyle As %String [ SqlColumnNumber = 8, SqlFieldName = OperDayStyle ];

/// 术次样式
Property OperDayStyleDr As ChartDict [ SqlColumnNumber = 23, SqlFieldName = OperDayStyleDr ];

/// 术次是否显示在天数后面
Property OperNumAfterDay(DISPLAYLIST = ",术次在后,术次在前", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = OperNumAfterDay ];

/// 手术最大天数
Property OperMaxDay As %String [ SqlColumnNumber = 9, SqlFieldName = OperMaxDay ];

/// 多次手术分割符
Property OperSeparator As %String [ SqlColumnNumber = 10, SqlFieldName = OperSeparator ];

/// 多次手术换页只显示最后一次
Property OperChangePage As %String(DISPLAYLIST = ",只显示最后一次,显示所有", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = OperChangePage ];

/// 多次手术只显示最后一次
Property OnlyLastOperDay As %String(DISPLAYLIST = ",只显示最后一次,显示所有", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = OnlyLastOperDay ];

/// 术次和天数连接符
Property OperConnector As %String [ SqlColumnNumber = 12, SqlFieldName = OperConnector ];

/// 换床显示规则
Property ChangeBedRule As %String [ SqlColumnNumber = 13, SqlFieldName = ChangeBedRule ];

/// 转科显示规则
Property TransLocRule As %String [ SqlColumnNumber = 14, SqlFieldName = TransLocRule ];

/// 日期格式
Property DateFormat As %String [ SqlColumnNumber = 15, SqlFieldName = DateFormat ];

/// 医院图标流字符串
Property HospIcon As %GlobalCharacterStream(LOCATION = "^CT.NUR.NIS.ChartDecodeS") [ SqlColumnNumber = 16, SqlFieldName = HospIcon ];

/// 医院图标宽
Property IconWidth As %String [ SqlColumnNumber = 17, SqlFieldName = IconWidth ];

/// 医院图标高
Property IconHeight As %String [ SqlColumnNumber = 18, SqlFieldName = IconHeight ];

/// 医院图标坐标X
Property IconX As %String [ SqlColumnNumber = 19, SqlFieldName = IconX ];

/// 医院图标坐标Y
Property IconY As %String [ SqlColumnNumber = 20, SqlFieldName = IconY ];

/// 红色时间点 
Property RedTimePoints As %String [ SqlColumnNumber = 21, SqlFieldName = RedTimePoints ];

/// 分娩事件指针
Property DeliveryEvent As User.MRCObservationItem [ SqlColumnNumber = 22, SqlFieldName = DeliveryEvent ];

/// 是否彩色打印
Property IfColorPrint As %String(DISPLAYLIST = ",彩色打印,黑白打印", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = IfColorPrint ];

/// 折线数据点是否居中
Property IfPointCellCenter As %String(DISPLAYLIST = ",居中,按时间", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = IfPointCellCenter ];

/// 同一时间点事件是否纵向
Property IfEventPortrait As %String(DISPLAYLIST = ",纵向,横向", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = IfEventPortrait ];

/// 多次手术只显示两个数字
Property OnlyTwoOperDay As %String(DISPLAYLIST = ",只显示两个数字,显示所有", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = OnlyTwoOperDay ];

/// 转科前后是否断线
Property IfBreakTransLoc As %String(DISPLAYLIST = ",断线,不断线", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = IfBreakTransLoc ];

/// 录入频次是2的体征项，上下午间隔时间点
Property IntervalTime As %String [ SqlColumnNumber = 31, SqlFieldName = IntervalTime ];

/// 上下午间隔时间点
Property IntervalTimeDr As ChartDict [ SqlColumnNumber = 32, SqlFieldName = IntervalTimeDr ];

/// 术次是否显示在事件后面
Property OperNumAfterEvent(DISPLAYLIST = ",术次在事件后,术次不在事件后", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = OperNumAfterEvent ];

/// 首日只显示0（包含规定的术次天数外的手术首日）
Property FirstDayZeroOutMD(DISPLAYLIST = ",首日显示0,首日不显示", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = FirstDayZeroOutMD ];

/// 术后天数内手术首日只计算最近一次手术天数
Property OnlyRecentOperDayFDInMD(DISPLAYLIST = ",首日只计算最近一次,计算所有", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = OnlyRecentOperDayFDInMD ];

/// 术后天数外手术只显示当前手术天数
Property OnlyCurOperDayOutMD(DISPLAYLIST = ",只显示当前,显示所有", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = OnlyCurOperDayOutMD ];

/// 多个药物过敏时显示“多种药物”
Property IfShowMultMed(DISPLAYLIST = ",显示多种药物,显示具体药物", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = IfShowMultMed ];

/// 同时段有生命体征时死亡事件后延一格显示
Property IfDeathEventDelay(DISPLAYLIST = ",后延一格显示,不后延", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = IfDeathEventDelay ];

/// 手术天数从0计算
Property OperDayCalcZero As %String(DISPLAYLIST = ",从0计算,不从0计算", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = OperDayCalcZero ];

/// 分娩日数计算在手术天数中
Property BirthInOperDays As %String(DISPLAYLIST = ",计算在手术天数中，不计算在手术天数中", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = BirthInOperDays ];

/// 分娩不计算术次
Property BirthNotCalcOperNum As %String(DISPLAYLIST = ",不计算术次，计算术次", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = BirthNotCalcOperNum ];

/// 皮试结果阳性显示文字(阳性/+)
Property SkinTestYText As %String [ SqlColumnNumber = 42, SqlFieldName = SkinTestYText ];

/// 阳性显示颜色
Property SkinTestYColor As %String [ SqlColumnNumber = 43, SqlFieldName = SkinTestYColor ];

/// 皮试结果阴性显示文字(阴性/-)
Property SkinTestNText As %String [ SqlColumnNumber = 44, SqlFieldName = SkinTestNText ];

/// 阴性显示颜色
Property SkinTestNColor As %String [ SqlColumnNumber = 45, SqlFieldName = SkinTestNColor ];

/// 录入频次是4的体征项，上午两个体征值间隔时间点
Property IntervalTimeAM As %String [ SqlColumnNumber = 46, SqlFieldName = IntervalTimeAM ];

/// 录入频次是4的体征项，下午两个体征值间隔时间点
Property IntervalTimePM As %String [ SqlColumnNumber = 47, SqlFieldName = IntervalTimePM ];

/// 录入频次是4的血压，上午/下午两个血压值同列显示
Property TwoBPInSameCol As %String(DISPLAYLIST = ",同列显示，同行显示", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = TwoBPInSameCol ];

/// 床号/科室扩展方向
Property BedLocExtDirec As %String [ SqlColumnNumber = 49, SqlFieldName = BedLocExtDirec ];

/// 床号取最后X次转床记录
Property RecentlyBeds As %String [ SqlColumnNumber = 50, SqlFieldName = RecentlyBeds ];

/// 血压显示次数
Property BPShowNums As %String [ SqlColumnNumber = 51, SqlFieldName = BPShowNums ];

/// 血压6测，上午第二个间隔时间点
Property IntervalTimeAM2 As %String [ SqlColumnNumber = 52, SqlFieldName = IntervalTimeAM2 ];

/// 血压6测，下午第二个间隔时间点
Property IntervalTimePM2 As %String [ SqlColumnNumber = 53, SqlFieldName = IntervalTimePM2 ];

/// 血压依次显示，如血压2次，第一个格子无值，需把原本要显示在第二个格子的值显示在第一个格子中，其他的依次
Property IfSequence As %String(DISPLAYLIST = ",依次显示，不依次显示", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = IfSequence ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CT.NUR.ChartDecode(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BPShowNums">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="BedLocExtDirec">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="BirthInOperDays">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="BirthNotCalcOperNum">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ChangeBedRule">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ChartDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DateFormat">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DeliveryEvent">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EventDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FirstDayZeroOutMD">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="HospIcon">
<Delimiter>"||"</Delimiter>
<Node>"Icon"</Node>
<Piece>1</Piece>
</Data>
<Data name="IconHeight">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IconWidth">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IconX">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IconY">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IfBreakTransLoc">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IfColorPrint">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IfDeathEventDelay">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="IfEventPortrait">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IfPointCellCenter">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IfSequence">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="IfShowMultMed">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="IntervalTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IntervalTimeAM">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="IntervalTimeAM2">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="IntervalTimeDr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IntervalTimePM">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="IntervalTimePM2">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="LinesJson">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OnlyCurOperDayOutMD">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OnlyLastOperDay">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OnlyRecentOperDayFDInMD">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OnlyTwoOperDay">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OperChangePage">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OperConnector">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OperDayCalcZero">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OperDayStyle">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OperDayStyleDr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OperMaxDay">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OperNumAfterDay">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OperNumAfterEvent">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OperSeparator">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PageDays">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RecentlyBeds">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="RedTimePoints">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SkinTestNColor">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SkinTestNText">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SkinTestYColor">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SkinTestYText">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="TextJson">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TimePoints">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TransLocRule">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TwoBPInSameCol">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Global>^CT.NUR.ChartDecode</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Row_ID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChartDr">
<Global>^CT.NUR.ChartDecode</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{Row_ID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Chart"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ChartDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Row_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Row_ID</SqlRowIdName>
<StreamLocation>^CT.NUR.NIS.ChartDecodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
