// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";
import {FHE} from "@fhevm/solidity/lib/FHE.sol";
import {euint32} from "@fhevm/solidity/lib/FHE.sol";

// online consultations platform
contract TelemedicineCore is ZamaEthereumConfig {
    struct Consultation {
        address patient;
        address doctor;
        euint32 symptoms;      // encrypted symptom data
        euint32 diagnosis;     // encrypted diagnosis
        uint256 scheduledAt;
        uint256 completedAt;
        bool completed;
    }
    
    mapping(uint256 => Consultation) public consultations;
    mapping(address => uint256[]) public patientConsultations;
    mapping(address => uint256[]) public doctorConsultations;
    uint256 public consultationCounter;
    
    event ConsultationScheduled(uint256 indexed consultationId, address patient, address doctor);
    event ConsultationCompleted(uint256 indexed consultationId);
    
    // schedule consultation
    function scheduleConsultation(
        address doctor,
        euint32 encryptedSymptoms,
        uint256 scheduledTime
    ) external returns (uint256 consultationId) {
        consultationId = consultationCounter++;
        consultations[consultationId] = Consultation({
            patient: msg.sender,
            doctor: doctor,
            symptoms: encryptedSymptoms,
            diagnosis: FHE.asEuint32(0),
            scheduledAt: scheduledTime,
            completedAt: 0,
            completed: false
        });
        
        patientConsultations[msg.sender].push(consultationId);
        doctorConsultations[doctor].push(consultationId);
        
        emit ConsultationScheduled(consultationId, msg.sender, doctor);
    }
    
    // doctor adds diagnosis
    function addDiagnosis(
        uint256 consultationId,
        euint32 encryptedDiagnosis
    ) external {
        Consultation storage consultation = consultations[consultationId];
        require(consultation.doctor == msg.sender, "Not your consultation");
        require(!consultation.completed, "Already completed");
        
        consultation.diagnosis = encryptedDiagnosis;
        consultation.completed = true;
        consultation.completedAt = block.timestamp;
        
        emit ConsultationCompleted(consultationId);
    }
}

