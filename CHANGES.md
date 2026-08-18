This file describes changes in the sglppow package.

# 2.6 (2026-08-18)

  - If available, use the `SmallGroupsAddLayer` function provided by `SmallGrp`

# 2.5 (2026-07-28)

  - Require GAP >= 4.10 and declare `smallgrp` as an explicit dependency
    (it used to be relied upon implicitly, as it is part of the default
    GAP distribution)
  - Fix typos in README and manual
  - Minor janitorial changes

# 2.4 (2024-03-20)

  - Include the HTML version of the manual in the release archive again

# 2.3 (2022-11-04)

  - Compress data files to reduce on-disk footprint

# 2.2 (2022-04-05)

  - Set license to Artistic License 2.0
  - Ensure the tests also pass if the LiePRing package is not available
  - Convert README to Markdown and integrate the copyright statement into it
  - Update installation instructions and various outdated URLs
  - Various janitorial changes

# 2.1 (2018-03-08)

  - Require GAP >= 4.7
  - Move the package website to https://gap-packages.github.io/sglppow/ and
    the sources to https://github.com/gap-packages/sglppow
  - Add tests based on the manual examples
  - Fix building the manual

# 2.0 (2016-08-11)

  - The package was accepted by the GAP council in August 2016
  - Add a chapter with installation instructions to the manual
  - Add examples to the manual, and various corrections and clarifications
    throughout it

# 1.1 (2016-01-22)

  - Correct the formula used by `NumberSmallGroups` for the number of groups
    of order p^7: its constant term is 2455, not 2

# 1.0 (2015-06-03)

  - Detect the LiePRing and LieRing packages via `IsPackageMarkedForLoading`
    instead of the obsolete `RequirePackage`
  - Add LieRing to the list of suggested packages

# 0.9 (2014-11-21)

  - Initial release
