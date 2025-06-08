import 'package:attendance/models/settings.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const inputColor = Color(0xFF2A2D33);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

// const reOffice = {1:'Grand Master', 2:'Grand Councillor', 3:'Regional Monitor', 4:'Worthy Master', 5:'Colombe', 6:'Deputy Master', 7:'Archivist', 8:'Chaplain', 9:'Outer Guardian', 10:'Inner Guardian', 11:'Conductor', 12:'Matre', 13:'Chanter', 14:'Chantress', 15:'Technician', 16:'D.I.', 17:'Torch Bearer', 18:'Herald', 19:'High Priestess', 20:'Medalist', 21:'Candidate'};

const Office = {1:'Worthy Master',  2:'Deputy Master', 3:'Archivist', 4:'Chaplain', 5:'Outer Guardian', 6:'Inner Guardian', 7:'Conductor', 8:'Matre', 9:'Chanter', 10:'Chantress', 11:'Technician', 12:'D.I.', 13:'Torch Bearer', 14:'Herald', 15:'High Priestess', 16:'Medalist', 17:'Candidate'};
const eventCats = {1:'Convocation', 2:'Business Meeting', 3:'Convocation by DM', 4:'Pythagoras', 5:'Thanksgiving', 6:'Workshop', 7:'Forum Class', 8:'Degree Class', 9: 'First Temple Degree Initiation', 10: 'Second Temple Degree Initiation', 11 : 'Third Temple Degree Initiation', 12: 'Fourth Temple Degree Initiation', 13: 'Fifth Temple Degree Initiation', 14: 'Sixth Temple Degree Initiation', 15: 'Seventh Temple Degree Initiation', 16: 'Eighth Temple Degree Initiation', 17: 'Ninth Temple Degree Initiation'};
const ABs = {1:'Thales Lodge', 2:'Dabaye Amaso Lodge', 3:'Akhnaton Chapter', 4:'Ee-Dee Pronaos', 5:'St Germain Pronaos', 6:'The Rose Pronaos', 7:'Arcane Pronaos', 0:'Not Affiliated',};
const GCAs ={1:'Rivers East', 2: 'Rivers West'};

const YesNo ={1:'Yes', 0: 'No'};

const male = 'Male';
const female = 'Female';
const String fileToDownload = 'members_sample.xlsx';
const candidate = 17;

SettingsLoad settingConst = SettingsLoad(id: 0, abID: 0, gcaID: 0, userName: 'SuchTree', tts: 0, ttsimple: 0);
