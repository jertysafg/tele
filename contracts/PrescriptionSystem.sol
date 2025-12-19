// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";
import {euint32} from "@fhevm/solidity/lib/FHE.sol";

// encrypted prescription system
contract PrescriptionSystem is ZamaEthereumConfig {
    struct Prescription {
        address patient;
        address doctor;
        euint32 medicationId;
        euint32 dosage;
        uint256 prescribedAt;
        bool filled;
    }
    
    mapping(uint256 => Prescription) public prescriptions;
    mapping(address => uint256[]) public patientPrescriptions;
    uint256 public prescriptionCounter;
    
    event PrescriptionCreated(uint256 indexed prescriptionId, address patient);
    event PrescriptionFilled(uint256 indexed prescriptionId);
    
    function createPrescription(
        address patient,
        euint32 encryptedMedicationId,
        euint32 encryptedDosage
    ) external returns (uint256 prescriptionId) {
        prescriptionId = prescriptionCounter++;
        prescriptions[prescriptionId] = Prescription({
            patient: patient,
            doctor: msg.sender,
            medicationId: encryptedMedicationId,
            dosage: encryptedDosage,
            prescribedAt: block.timestamp,
            filled: false
        });
        
        patientPrescriptions[patient].push(prescriptionId);
        emit PrescriptionCreated(prescriptionId, patient);
    }
    
    function markFilled(uint256 prescriptionId) external {
        Prescription storage prescription = prescriptions[prescriptionId];
        require(prescription.patient == msg.sender, "Not your prescription");
        prescription.filled = true;
        emit PrescriptionFilled(prescriptionId);
    }
}

