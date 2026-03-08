# ecotide Service-Grade SPECKIT

Last updated: 2026-03-08

## S - Scope
- 대상: SwiftUI environmental simulation app
- baseline 목표: simulation telemetry, motion fallback, package build 신뢰도를 서비스 수준으로 고정

## P - Product Thesis
- EcoTide는 단순 SwiftUI toy가 아니라 `interactive simulation product`로 보여야 한다.
- motion input이 없어도 graceful fallback과 telemetry clarity가 있어야 한다.

## E - Execution
- simulation loop와 telemetry overlay의 의도를 README와 code structure에서 분명히 유지
- CLI fallback / Swift package build를 검증 가능한 baseline으로 유지
- simulation review pack을 in-app telemetry deck과 CLI fallback에 같이 노출
- 이번 baseline에서 Swift CI를 추가해 기본 build health를 자동 확인

## C - Criteria
- `swift build` green
- README에서 simulation 목적과 fallback 동작이 즉시 이해됨
- package build/workflow가 main push에서 자동 실행됨

## K - Keep
- tactile simulation feel
- fallback-friendly design

## I - Improve
- simulator/device screenshots와 telemetry panel mock 추가
- gameplay loop 설명 강화

## T - Trace
- `README.md`
- `Package.swift`
- `SimulationScene.swift`
- `.github/workflows/ci.yml`
