import 'package:attendance/models/settings.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const inputColor = Color(0xFF2A2D33);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

const Office = {1:'Worthy Master', 2:'Deputy Master', 3:'Archivist', 4:'Chaplain', 5:'Outer Guardian', 6:'Inner Guardian', 7:'Conductor', 8:'Matre', 9:'Chanter', 10:'Chantress', 11:'Technician', 12:'D.I.', 13:'Torch Bearer', 14:'Herald', 15:'High Priestess', 16:'Medalist', 17:'Candidate'};
const eventCats = {1:'Convocation', 2:'Business Meeting', 3:'Convocation by DM', 4:'Pythagoras', 5:'Thanksgiving', 6:'Workshop', 7:'Forum Class', 8:'Degree Class', 9: '1st Temple Degree Initiation', 10: '2nd Temple Degree Initiation', 11 : '3rd Temple Degree Initiation', 12: '4th Temple Degree Initiation', 13: '5th Temple Degree Initiation', 14: '6th Temple Degree Initiation', 15: '7th Temple Degree Initiation', 16: '8th Temple Degree Initiation', 17: '9th Temple Degree Initiation'};
const ABs = {1:'Thales Lodge', 2:'Dabaye Amaso Lodge', 3:'Akhnaton Chapter', 4:'Ee-Dee Pronaos', 5:'St Germain Pronaos', 6:'The Rose Pronaos', 7:'Arcane Pronaos', 0:'Not Affiliated',};
const GCAs ={1:'Rivers'};

const YesNo ={1:'Yes', 0: 'No'};

const male = 'Male';
const female = 'Female';
const String fileToDownload = 'members_sample.xlsx';

SettingsLoad settingConst = SettingsLoad(id: 0, abID: 0, gcaID: 0, userName: 'SuchTree');
